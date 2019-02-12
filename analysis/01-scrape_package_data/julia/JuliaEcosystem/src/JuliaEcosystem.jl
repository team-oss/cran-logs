"""
    JuliaEcosystem.jl

    This module is used to generate a text file with
        name, version, dependency, repository
    information for all registered installable packages
"""
module JuliaEcosystem
    using Base.Iterators: flatten
    using CSV: CSV, File
    using HTTP: request
    using Pkg: METADATA_compatible_uuid
    using Pkg.Operations: load_package_data_raw, deps_graph, simplify_graph!, resolve
    using Pkg.TOML: parsefile
    using Pkg.Types: Context, Fixed, Requires, UUID, uuid_julia, VersionRange, VersionSpec
    # Record information about the registry
    """
        All package names in the General registry
    """
    const pkgs =
        readdir.(joinpath.(homedir(), ".julia/registries/General", string.('A':'Z'))) |>
        flatten |>
        collect |>
        (x -> filter!(x -> ~any(x ∈ ["julia", ".DS_Store"]), x))
    const deps = Dict{UUID,Dict{VersionRange,Dict{String,UUID}}}()
    const compat = Dict{UUID,Dict{VersionRange,Dict{String,VersionSpec}}}()
    const uuid_to_name =
        Dict(UUID("ade2ca70-3891-5945-98fb-dc099432e06a")=>"Dates",
             UUID("7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee")=>"FileWatching",
             UUID("ea8e919c-243c-51af-8825-aaa63cd721ce")=>"SHA",
             UUID("6462fe0b-24de-5631-8697-dd941f90decc")=>"Sockets",
             UUID("8bb1440f-4735-579b-a4ab-409b98df4dab")=>"DelimitedFiles",
             UUID("9a3f8284-a2c9-5f02-9a11-845980a1fd5c")=>"Random",
             UUID("8ba89e20-285c-5b6f-9357-94700520ee1b")=>"Distributed",
             UUID("37e2e46d-f89d-539d-b4ee-838fcccc9c8e")=>"LinearAlgebra",
             UUID("a63ad114-7e13-5084-954f-fe012c677804")=>"Mmap",
             UUID("2f01184e-e22b-5df5-ae63-d93ebab69eaf")=>"SparseArrays",
             UUID("cf7118a7-6976-5b1a-9a39-7adc72f591a4")=>"UUIDs",
             UUID("56ddb016-857b-54e1-b83d-db4d58db5568")=>"Logging",
             UUID("10745b16-79ce-11e8-11f9-7d13ad32a3b2")=>"Statistics",
             UUID("8bf52ea8-c179-5cab-976a-9e18b702a9bc")=>"CRC32c",
             UUID("44cfe95a-1eb2-52ea-b672-e2afdf69b78f")=>"Pkg",
             UUID("9e88b42a-f829-5b0c-bbe9-9e923198166b")=>"Serialization",
             UUID("d6f4376e-aef5-505a-96c1-9c027394607a")=>"Markdown",
             UUID("4607b0f0-06f3-5cda-b6b1-a6196a1729e9")=>"SuiteSparse",
             UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb")=>"REPL",
             UUID("8f399da3-3557-5675-b5ff-fb832c97cbdb")=>"Libdl",
             UUID("2a0f44e3-6c83-55bd-87e4-b1978d98bd5f")=>"Base64",
             UUID("9abbd945-dff8-562f-b5e8-e1ebf5ef1b79")=>"Profile",
             UUID("b77e0a4c-d291-57a0-90e8-8db25a27a240")=>"InteractiveUtils",
             UUID("1a1011a3-84de-559e-8e89-a11a2f7dc383")=>"SharedArrays",
             UUID("de0858da-6303-5e67-8744-51eddeeeb8d7")=>"Printf",
             UUID("9fa8497b-333b-5362-9e8d-4d0656e87820")=>"Future",
             UUID("76f85450-5226-5b5a-8eaa-529ad045b433")=>"LibGit2",
             UUID("8dfed614-e22c-5e08-85e1-65c5234f0b40")=>"Test",
             UUID("4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5")=>"Unicode",
             uuid_julia=>"julia")
    const versions = Dict{UUID,Set{VersionNumber}}()
    for pkg ∈ pkgs
        dir = joinpath(homedir(), ".julia/registries/General", uppercase(pkg[1:1]), pkg)
        uuid = UUID(parsefile(joinpath(dir, "Package.toml"))["uuid"])
        uuid_to_name[uuid] = pkg
        versions[uuid] = Set(VersionNumber.(keys(parsefile(joinpath(dir, "Versions.toml")))))
        deps[uuid] = load_package_data_raw(UUID, joinpath(dir, "Deps.toml"))
        compat[uuid] = load_package_data_raw(VersionSpec, joinpath(dir, "Compat.toml"))
    end
    """
        parse_pkg(pkg::AbstractString)::Vector{NamedTuple{(:name, :version, :dependency, :repository)}}

        Given a pkg, it returns the name, version, dependencies, and repository if installable
    """
    function parse_pkg(pkg)
        # First get the package information
        #dir = joinpath(homedir(), ".julia/registries/General", pkg[1:1], pkg)
	dir = joinpath(homedir(), ".julia/registries/General", uppercase(pkg[1:1]), pkg)
        package = parsefile(joinpath(dir, "Package.toml"))
        name = package["name"]
        repo = replace(package["repo"], r"\.git$" => "")
        uuid = UUID(package["uuid"])
        # Verify that it can be installed for Julia 1 (current LTS release)
        try
            graph = deps_graph(Context(),
                               uuid_to_name,
                               Requires(uuid => VersionSpec()),
                               Dict(uuid_julia => Fixed(v"1")))
            simplify_graph!(graph)
            solved = resolve(graph)
            version = solved[uuid]
            dependencies = get.(Ref(uuid_to_name),
                                filter(!isequal(uuid), keys(solved)),
                                nothing) |>
                           sort!
            # Check whether the repository exists or redirects
            # If it isn't accessible it is not installable
            # If it redirects, updates to the current resource location
            response = request("GET", repo)
            if !isa(response.request.parent, Nothing)
                # It redirected so replace with final address
                repo = header(response.request.parent, "Location")
            end
            map(dependency -> (name = name,
                               version = version,
                               dependency = dependency,
                               repository = repo),
                vcat("Julia", dependencies))
        catch
            Vector{NamedTuple{(:name, :version, :dependency, :repository)}}()
        end
    end
    __init__() = CSV.write("data/julia.tsv",
              mapreduce(parse_pkg, vcat, pkgs),
              delim = "\t")
end
