ARG REGISTRY
FROM ${REGISTRY}/ncigdc/bio-alpine:cwltool

ARG WORKFLOW

COPY ./${WORKFLOW} /opt 
COPY ./tools /tools
COPY ./subworkflows /subworkflows

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]

