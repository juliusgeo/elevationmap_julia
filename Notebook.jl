
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
	        return arr[newcoords[2], newcoords[1]]
	    end
	end
end

getelev(38.735375,-77.410316)

using LightXML


xdoc = parse_file("map.osm")

# get the root element
xroot = root(xdoc)  # an instance of XMLElement
# print its name
println(name(xroot))  # this should print: bookstore

# traverse all its child nodes and print element names
for way in xroot["way"]  # c is an instance of XMLNode
    for tag in way["tag"]
        println(attribute(tag, "k"))
        if()
    end
end


attribute(xroot["way"][1]["tag"][1], "k")


