module CLIWrappers

using TSML
using TSML.TSMLTypes
using TSML.TSMLTransformers
using TSML.Utils

using TSML.DataReaders
using TSML.DataWriters
using TSML.Statifiers
using TSML.Monotonicers

using Dates
using DataFrames
using CSV

export tsmlrun

const COMMONARG = Dict(:dateformat=>"dd/mm/yyyy HH:MM",
                        :dateinterval=>Dates.Hour(1),
                        :processmissing=>true
                       )

function tsmlrun(inputname::AbstractString,outputname::AbstractString="",datefmt::AbstractString="dd/mm/yyyy HH:MM",otype::AbstractString="table")
    res = DataFrame()
    if otype == "table"
        res=imputedoutput(inputname,outputname,datefmt)
    elseif otype == "stat"
        res=imputedstat(inputname,outputname,datefmt)
    else
        error("wrong output type")
    end
    res
end

function rawstat(inputname::AbstractString,outputname::AbstractString="",datefmt::AbstractString="dd/mm/yyyy HH:MM")
    isfile(inputname) || error("input file name does not exist")
    csvreader = DataReader(Dict(:filename=>inputname,:dateformat=>datefmt))
    stfier = Statifier()
    lpipe = Pipeline(Dict(
        :transformers => [csvreader,stfier]
      )
    )
    fit!(lpipe)
    res=transform!(lpipe)
    if outputname != ""
        res |> CSV.write(outputname)
    end
    return res
end

function aggregatedstat(inputname::AbstractString,outputname::AbstractString="",datefmt::AbstractString="dd/mm/yyyy HH:MM")
    isfile(inputname) || error("input file name does not exist")
    csvreader = DataReader(Dict(:filename=>inputname,:dateformat=>datefmt))
    valgator = DateValgator(COMMONARG)
    stfier = Statifier()
    lpipe = Pipeline(Dict(
        :transformers => [csvreader,valgator,stfier]
      )
    )
    fit!(lpipe)
    res=transform!(lpipe)
    if outputname != ""
        res |> CSV.write(outputname)
    end
    return res
end

function aggregatedoutput(inputname::AbstractString,outputname::AbstractString="",datefmt::AbstractString="dd/mm/yyyy HH:MM")
    isfile(inputname) || error("input file name does not exist")
    csvreader = DataReader(Dict(:filename=>inputname,:dateformat=>datefmt))
    valgator = DateValgator(COMMONARG)
    lpipe = Pipeline(Dict(
        :transformers => [csvreader,valgator]
      )
    )
    fit!(lpipe)
    res=transform!(lpipe)
    if outputname != ""
        res |> CSV.write(outputname)
    end
    return res
end

function imputedstat(inputname::AbstractString,outputname::AbstractString="",datefmt::AbstractString="dd/mm/yyyy HH:MM")
    isfile(inputname) || error("input file name does not exist")
    csvreader = DataReader(Dict(:filename=>inputname,:dateformat=>datefmt))
    valgator = DateValgator(COMMONARG)
    valnner = DateValNNer(COMMONARG)
    mononicer = Monotonicer()
    stfier = Statifier()
    lpipe = Pipeline(Dict(
        :transformers => [csvreader,valgator,valnner,mononicer,stfier]
      )
    )
    fit!(lpipe)
    res=transform!(lpipe)
    if outputname != ""
        res |> CSV.write(outputname)
    end
    return res
end

function imputedoutput(inputname::AbstractString,outputname::AbstractString="",datefmt::AbstractString="dd/mm/yyyy HH:MM")
    isfile(inputname) || error("input file name does not exist")
    csvreader = DataReader(Dict(:filename=>inputname,:dateformat=>datefmt))
    valgator = DateValgator(COMMONARG)
    valnner = DateValNNer(COMMONARG)
    mononicer = Monotonicer()
    stfier = Statifier()
    lpipe = Pipeline(Dict(
        :transformers => [csvreader,valgator,valnner,mononicer]
      )
    )
    fit!(lpipe)
    res=transform!(lpipe)
    if outputname != ""
        res |> CSV.write(outputname)
    end
    return res
end

end