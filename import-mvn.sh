#!/usr/bin/env bash
DB=${1-/servers/neo4j/neotest.db}
shift
NODES=${1-../data/directoryx_sample2.csv}
shift
RELS=${1-../data/directoryx_rel2.csv}
shift
mvn compile exec:java -Dexec.mainClass="org.neo4j.batchimport.Importer" \
   -Dexec.args="batch.properties $DB $NODES $RELS $*" | grep -iv '\[\(INFO\|debug\)\]'
