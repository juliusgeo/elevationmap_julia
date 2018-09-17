import ArchGDAL
ArchGDAL.registerdrivers() do
    ArchGDAL.read("srtm_21_05.tif") do dataset
        print(dataset)
        band = ArchGDAL.getband(dataset, 1)
        geotransform = ArchGDAL.getgeotransform(dataset)
        print(geotransform)
        arr = ArchGDAL.read(band)
    end
end