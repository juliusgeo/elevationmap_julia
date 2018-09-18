
import ArchGDAL
using BenchmarkTools

function geo2pixel(gt, x, y)
	Int64(round((x-gt[4])/gt[6])), Int64(round((y-gt[1])/gt[2]))
end
ArchGDAL.registerdrivers() do
    ArchGDAL.read("srtm_21_05.tif") do dataset
        global arr = ArchGDAL.read(ArchGDAL.getband(dataset, 1))
        global geotransform = ArchGDAL.getgeotransform(dataset)
    end
end
function getelev(x, y)
    newcoords = geo2pixel(geotransform, x, y)
    return arr[newcoords[2], newcoords[1]]
end



using LightXML

xdoc = parse_file("map.osm")

# get the root element
struct Node
    x::Float64
    y::Float64
    elevation::Int
    id::String
end
node_arr = Any[]
xroot = root(xdoc)  # an instance of XMLElement
for node in xroot["node"]
    id = attribute(node, "id")
    lat = parse(Float64, attribute(node, "lat"))
    lon = parse(Float64, attribute(node, "lon"))
    elevation = getelev(lat, lon)
    push!(node_arr, Node(lat, lon, elevation, id))
    println(node_arr[end])
end


function findnode(id::String)
    return node_arr[findfirst(x -> x.id == "37021436", node_arr)]
end

struct Tag
    key::String
    val::String
end
mutable struct Way
    id::String
    visible::Bool
    version::Int
    changeset::String
    timestamp::String
    user::String
    uid::String
    nodes::Array{Node}
    tags::Array{Tag}
    Way() = new()
end



function parse_ways(xroot::XMLElement)
    way_arr = []
    for way in xroot["way"]  # c is an instance of XMLNode
        cur_way = Way()
        cur_way.id = attribute(way, "id")
        cur_way.visible = lowercase(attribute(way, "visible")) == "true"
        cur_way.version = parse(Int, attribute(way, "version"))
        cur_way.changeset = attribute(way, "changeset")
        cur_way.timestamp = attribute(way, "timestamp")
        cur_way.user = attribute(way, "user")
        cur_way.uid = attribute(way, "uid")
        cur_way.nodes = []
        for node in way["nd"]
            push!(cur_way.nodes, findnode(attribute(node, "ref")))
        end
        cur_way.tags = []
        for tag in way["tag"]
            push!(cur_way.tags, Tag(attribute(tag, "k"), attribute(tag, "v")))
        end
        push!(way_arr, cur_way)
    end
    return way_arr
end



@btime way_arr = parse_ways(xroot)

@btime findnode("37021436")

xroot["way"][1]


