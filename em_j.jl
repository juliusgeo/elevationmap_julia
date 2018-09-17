import ArchGDAL

function geo2pixel(gt, x, y)
	Int64(round((x-gt[4])/gt[6])), Int64(round((y-gt[1])/gt[2]))
end
function getelev(x, y)
	ArchGDAL.registerdrivers() do
	    ArchGDAL.read("srtm_21_05.tif") do dataset
	        band = ArchGDAL.getband(dataset, 1)
	        geotransform = ArchGDAL.getgeotransform(dataset)
	        arr = ArchGDAL.read(band)
	        newcoords = geo2pixel(geotransform, x, y)
	        print(arr[newcoords[2], newcoords[1]])
	    end
	end
end
getelev(38.735375,-77.410316)
