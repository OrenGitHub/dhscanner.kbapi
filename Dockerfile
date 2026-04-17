FROM haskell:9.6.7 AS builder

WORKDIR /build

COPY dhscanner-kbapi.cabal VERSION ./
COPY src/ src/
COPY json-schema-creator/ json-schema-creator/

RUN cabal update && cabal build json-schema-creator

RUN cabal run json-schema-creator

FROM scratch AS output

COPY --from=builder /build/query.schema.json /
COPY --from=builder /build/query_result.schema.json /
