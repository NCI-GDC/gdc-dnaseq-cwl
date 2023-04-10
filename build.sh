#!/bin/bash -x
set -o pipefail

while getopts b:n:t: option; do
	case "${option}" in

	b) BRANCH=${OPTARG} ;;
	n) BUILDNUMBER=${OPTARG} ;;
	*) echo "${OPTARG}" not supported! ;;
	esac
done

export DOCKER_BUILDKIT=1
export BUILDKIT_STEP_LOG_MAX_SIZE=10485760
export BUILDKIT_STEP_LOG_MAX_SPEED=1048576

BASE_CONTAINER_REGISTRY=${BASE_CONTAINER_REGISTRY:-docker.osdc.io}
PROXY=${PROXY:-}
BRANCH="${BRANCH-}"
GIT_DESCRIBE=$(git describe --tags --always)
BUILD_ROOT_DIR=$(pwd)

CLEAN_BRANCH_NAME=${BRANCH/\//_}
LOWERCASE_BRANCH_NAME="$(tr "[:upper:]" "[:lower:]" <<<"$CLEAN_BRANCH_NAME")"
CURRENT_VERSION="${LOWERCASE_BRANCH_NAME}-${BUILDNUMBER}"

# As what versions (i.e., "...:version") to tag the build images.
TAG_VERSIONS=("${CURRENT_VERSION}" "${GIT_DESCRIBE}")

# Initialize Registry array
REGISTRIES=()
if [ "$BRANCH" = "$CI_DEFAULT_BRANCH" ] || [ -n "$SCM_TAG" ]; then
	# Which internal registry to push the images to.
	REGISTRIES+=("containers.osdc.io" "quay.io")

	# Add datetime to version tags
	DATETIME_VERSION="$(date -u +'%Y%m%dT%H%MZ')"
	TAG_VERSIONS+=("${DATETIME_VERSION}")
else
	REGISTRIES+=("dev-containers.osdc.io")
fi

# Populate the IMAGE_TAGS variable with an array listing the tags to set,
# including all versions and registries. Pass the "directory" of the image
# as an argument.
function populate_image_tags() {
	IMAGE_TAGS=()
	for REGISTRY in "${REGISTRIES[@]}"; do
		for TAG_VERSION in "${TAG_VERSIONS[@]}"; do
			IMAGE_TAGS+=("${REGISTRY}/ncigdc/$1:${TAG_VERSION}")
		done
	done
}

set -e
for directory in *; do
	if [ -d "${directory}" ]; then

		if [ ! -f "${directory}"/Dockerfile ]; then
			cd "$BUILD_ROOT_DIR"
			continue
		fi

		cd "${directory}"

		echo "Building ${directory} ..."
		docker buildx build --compress --progress plain \
			-t "build-${directory}:${CURRENT_VERSION}" \
			-f Dockerfile .. \
			--build-arg CURRENT_VERSION="${CURRENT_VERSION}" \
			--build-arg REGISTRY="${BASE_CONTAINER_REGISTRY}" \
			--label org.opencontainers.image.version="${CURRENT_VERSION}" \
			--label org.opencontainers.image.created="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
			--label org.opencontainers.image.revision="$(git rev-parse --short HEAD)" \
			--label org.opencontainers.ref.name="${directory}:${CURRENT_VERSION}" \
			--build-arg http_proxy="${PROXY}" \
			--build-arg https_proxy="${PROXY}" \
			--build-arg WORKFLOW="${directory}"

		# Assign the final tags now so later images can build on this one.
		populate_image_tags "${directory}"
		for TAG in "${IMAGE_TAGS[@]}"; do
			docker tag "build-${directory}:${CURRENT_VERSION}" "$TAG"
		done

		docker rmi "build-${directory}:${CURRENT_VERSION}"
		cd ..
	fi
done

echo "Successfully built all containers!"

cd "$BUILD_ROOT_DIR"

if [[ -n "$GITLAB_CI" ]]; then
	# Only publish on CI
	for directory in *; do
		if [ -d "${directory}" ]; then

			if [ ! -f "${directory}"/Dockerfile ]; then
				continue
			fi

			echo "Pushing and cleaning up."

			populate_image_tags "${directory}"
			for TAG in "${IMAGE_TAGS[@]}"; do
				docker push "${TAG}"
				docker rmi "${TAG}"
				echo "${TAG} is all set"
			done
		fi
	done
fi
echo "All done!"
