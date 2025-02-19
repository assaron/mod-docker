#!/bin/bash -e

DATA_DIR=/mod/mod-host/mod-lv2-data
LV2_ABS_DIR=/usr/lib/lv2

for i in `comm -12 <(ls ${DATA_DIR}/plugins-fixed | grep -v bad) <(ls ${LV2_ABS_DIR})`; do
    if test -e ${LV2_ABS_DIR}/$i/modgui; then
        echo Skipping copying lv2 data over $i as it already contains modgui.
    else
        echo Copying $i data...;
        # don't overwrite existing ttls
        cp -n -r ${DATA_DIR}/plugins-fixed/$i ${LV2_ABS_DIR}/
        # do overwrite manifest.ttl
        cp ${DATA_DIR}/plugins-fixed/$i/manifest.ttl ${LV2_ABS_DIR}/$i/manifest.ttl
    fi
done

for i in `comm -12 <(ls ${DATA_DIR}/plugins | grep -v bad) <(ls ${LV2_ABS_DIR})`; do
    if test -e ${LV2_ABS_DIR}/$i/modgui; then
        echo Skipping copying lv2 data over $i as it already contains modgui.
    else 
        if test -e ${DATA_DIR}/plugins/$i/modgui; then
            echo Copying $i data...;
            # don't overwrite existing ttls
            cp -n -r ${DATA_DIR}/plugins/$i ${LV2_ABS_DIR}/
            # do overwrite manifest.ttl
            cp ${DATA_DIR}/plugins/$i/manifest.ttl ${LV2_ABS_DIR}/$i/manifest.ttl
        else
            echo Skipping $i with no modgui folder...
        fi
    fi
done

ls -1 ${LV2_ABS_DIR}/
ls -1 ${LV2_ABS_DIR}/ | wc -l
