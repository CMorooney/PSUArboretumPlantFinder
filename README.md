# PSU Arboretum Plant Finder iOS application

![](img/map1.png)
![](img/map2.png)
![](img/detail.png)
![](img/location_selector.png)
![](img/about.png)
![](img/settings.png)

---

**Please Note:**
This application is **not** developed by or in association with
the Pennsylvania State University (PSU) or the Arboretum _at_ PSU.
It exists purely as an educational tool for building a map-based
application with the latest:

- swiftui mapkit
- [TheComposableArchitecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Realm](https://realm.io/realm-swift/)

The data displayed is meticulously managed by [the hard working Arboretum staff](https://arboretum.psu.edu/about/staff/)
and was pulled from their own public [interactive web map](https://datacommons.maps.arcgis.com/apps/webappviewer/index.html?id=88d9267530dc48db8635703130bb084e).

No work is being done by this developer to manage collections or the related data.

---

I ripped plant finder data from [the interactive arcGIS/ESRI map](https://datacommons.maps.arcgis.com/apps/webappviewer/index.html?id=88d9267530dc48db8635703130bb084e)
and am just loading locally for now. (raw.json in Data dir)

This is the request I used for the latest raw data file that
includes the proper projection (Mercator -- default was returning NAD 1983):

```
https://apps.pasda.psu.edu/arcgis/rest/services/PlantFinder_Combined_Accessions_01212019/FeatureServer/0/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometry=%7B%22xmin%22%3A-8668570.5047493%2C%22ymin%22%3A4983694.245496575%2C%22xmax%22%3A-8667959.008523071%2C%22ymax%22%3A4984305.741722804%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=4326&resultType=til
```

the important think here was using the value `4326` for `outSR` query param
which is [the wkid for mercator](https://github.com/Esri/projection-engine-db-doc/blob/main/json/pe_list_geogcs.json#L4538)

## todo

todo has been moved to a [Github Project](https://github.com/users/CMorooney/projects/1/views/1)
which link to [issues](https://github.com/CMorooney/PSUArboretumPlantFinder/issues)
