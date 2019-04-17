using Documenter
using LogarithmicNumbers

makedocs(
    sitename = "LogarithmicNumbers",
    format = Documenter.HTML(),
    modules = [LogarithmicNumbers],
    pages = ["Home" => "index.md", "Guide" => "guide.md", "Interoperability" => "interop.md"]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
