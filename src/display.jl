
# methods to translate

"""return the frequency ticks of a spectrogram, rounded to the nearest integers"""
function yticklabels(tfr::DSP.Periodograms.Spectrogram, yticks::Array)
    map(Int, map(round, yticks)), "frequency (Hz)"
end

"""return Hz values corresponding to given mel frequencies"""
function yticklabels(tfr::MelSpectrogram, yticks::Array)
    map(Int, map(round, mel_to_hz(yticks))), "frequency (Hz)"
end

"""return MFCC coefficient numbers"""
function yticklabels(tfr::MFCC, yticks::Array)
    map(Int, map(round, yticks)), "MFCC number"
end

heatmap(tfr::DSP.Periodograms.TFR) = log10(power(tfr))

function draw_heatmap(tfr::DSP.Periodograms.TFR)
    X = time(tfr)
    Y = freq(tfr)
    Z = heatmap(tfr)

    PyPlot.pcolormesh(X, Y, Z)
    PyPlot.xlim(first(X), last(X))
    PyPlot.ylim(first(Y), last(Y))

    (yticks, ylabel) = yticklabels(tfr, PyPlot.yticks()[1])
    PyPlot.gca()[:set_yticklabels](yticks)
    PyPlot.gca()[:spines]["top"][:set_visible](false)
    PyPlot.gca()[:spines]["right"][:set_visible](false)

    PyPlot.xlabel("time (seconds)")
    PyPlot.ylabel(ylabel)
end

"""Display a spectrogram"""
function Base.show(io::IO, mime::MIME"image/png", tfr::R) where {R <: DSP.Periodograms.TFR}
    @eval import PyPlot
    PyPlot.ioff()
    PyPlot.figure(figsize=(8, 4))
    draw_heatmap(tfr)
    show(io, mime, PyPlot.gcf())
end

"""Display multichannel spectrogram"""
function Base.show(io::IO, mime::MIME"image/png", tfrs::Array{R, 1}) where {R <: DSP.Periodograms.TFR}
    nchannel = length(tfrs)

    @eval import PyPlot
    PyPlot.ioff()
    PyPlot.figure(figsize=(8, 8))

    for i = 1:nchannel
        PyPlot.subplot(nchannel, 1, i)
        draw_heatmap(tfrs[i])

        if i != nchannel
            PyPlot.gca()[:get_xaxis]()[:set_visible](false)
            PyPlot.gca()[:spines]["bottom"][:set_visible](false)
        end
    end
    show(io, mime, PyPlot.gcf())
end
