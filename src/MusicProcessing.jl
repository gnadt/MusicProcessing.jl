module MusicProcessing

using DSP
using FFTW
using FixedPointNumbers
using IntervalSets
using Requires
using SampledSignals
using Statistics
using Unitful
using Unitful: ns, ms, µs, s, Hz, kHz, MHz, GHz, THz
using LinearAlgebra: mul!, norm
import SampledSignals: mono, nchannels, nframes

# types used for fixed-point 16-bit and 32-bit encoding
const PCM16Sample = Fixed{Int16, 15}
const PCM32Sample = Fixed{Int32, 31}

export Hz, kHz, s, ..
export PCM16Sample, PCM32Sample

include("audio.jl")
include("chroma.jl")
include("complex.jl")
include("constantq.jl")
include("mel.jl")
include("TFR.jl")
include("util.jl")

export AbstractSampleBuf, SampleBuf, SpectrumBuf, mono, nchannels, nframes
export resample, duration, play, pitchshift, speedup, slowdown, zero_crossing_rate
export melspectrogram, mfcc
export spectrogram, stft, istft, phase_vocoder

function __init__()
    @require PyPlot="d330b81b-6aea-500a-939a-2ce795aea3ee" include("display.jl")
end

end # module
