# Generalized Phase

This repository contains code and demonstrations implementing the "generalized phase" (GP) representation introduced in:

> [Davis*, Muller*, Martinez-Trujillo, Sejnowski, Reynolds. Spontaneous travelling cortical waves gate perception in behaving primates. *bioRxiv*, 2019. (*equal contribution)](https://www.biorxiv.org/content/10.1101/811471v1)

The GP representation is a comprehensive numerical implementation of the "analytic signal" paradigm originally introduced by Denis Gabor in 1946 ([ref](https://ieeexplore.ieee.org/document/5298517)). This paradigm established the concepts of "instantaneous frequency" and "instantaneous phase"; however, in practice, technical limitations can cause breakdowns of the representation. Specifically, low-frequency intrusions effectively shift the analytic signal representation by a constant in the complex plane, which in turn can strongly distort angles estimated by the four-quadrant arctangent function. High-frequency intrusions can introduce negative-frequency components, in which estimated phase progression reverses direction. We correct these technical limitations by (1) ensuring the representation remains centered in the complex plane and (2) detecting and correcting negative frequency components. 

This approach, along with quantitative statistics for assessing the quality of the GP representation, constitutes a numerical implementation of the analytic signal paradigm suitable for analyzing wideband signals without first applying narrowband filters, which can introduce significant waveform distortion. For this reason, we call our updated approach "generalized phase" (GP). The file [gp_demo.m](gp_demo.m) creates an example timeseries plot demonstrating the GP representation on an LFP trace recorded in visual cortex:

<p align="center">
	<img src="https://mullerlab.ca/assets/img/gp-demo/gp_demo.png">
</p>

## Dependencies

You will need the [wave](https://github.com/mullerlab/wave-matlab) toolbox from our lab to run the demonstrations in this repository. This can be added to the MATLAB path manually or using the command:

```
>> addpath( '/path/to/wave-matlab' )
```

The functions in this repository also use [CircStat](https://github.com/circstat/circstat-matlab) by Philipp Berens and [smoothn](https://www.mathworks.com/matlabcentral/fileexchange/25634-smoothn) by Damien Garcia. Note that the file [gp_demo.m](gp_demo.m) uses [cline](https://www.mathworks.com/matlabcentral/fileexchange/14677-cline) and [colorcet](https://peterkovesi.com/projects/colourmaps) to create the plot.

## Installation

First, download or clone the repository:

```
git clone https://github.com/mullerlab/gp-demo
```

Then navigate to the installation. Once you have all dependencies ready on the MATLAB path (see above), you will be able to run the demonstrations in this repository.

## Spontaneous Waves Demo

[spontaneous_wave_demo.m](spontaneous_wave_demo.m) demonstrates the GP representation applied to Utah multielectrode array recordings in extrastriate visual cortex of the marmoset. The code loads a set of trials (spikes + LFP), calculates GP (line 44), implements the algorithm for detection of spontaneous traveling waves (lines 47-68), and calculates the GP at which spikes occur during fixation (lines 73-79). Note that in the example wave plots (line 71), no smoothing is applied to the data. To visualize the same data with randomized spatial structure, "options.shuffle_channels" can be set to "true".

## Developers

[Lyle Muller](http://mullerlab.ca) (Western University) and Zac Davis (Salk Institute)
