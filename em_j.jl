import ArchGDAL

function geo2pixel(gt, x, y)
	pixelY = Int64(round((y-gt[1])/gt[2]))
	pixelX = Int64(round((x-gt[4])/gt[6]))
	return (pixelX, pixelY)
end
function getelev(x, y)
	ArchGDAL.registerdrivers() do
	    ArchGDAL.read("srtm_21_05.tif") do dataset
	        print(dataset)
	        band = ArchGDAL.getband(dataset, 1)
	        geotransform = ArchGDAL.getgeotransform(dataset)
	        print(geotransform)
	        arr = ArchGDAL.read(band)
	        newcoords = geo2pixel(geotransform, x, y)
	        print(newcoords)
	        print(arr[newcoords[2], newcoords[1]])
	    end
	end
end
getelev(38.735375,-77.410316)
