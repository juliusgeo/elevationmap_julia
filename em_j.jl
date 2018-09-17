using ArchGDAL
ArchGDAL.registerdrivers() do
    ArchGDAL.read("srtm_21_05.tif") do dataset
        print(dataset)
    end
end