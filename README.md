# Biophysical_Models (Physiological Models)
Hodgkin–Huxley model is a mathemetical description given by Alan Hodgkin and Andrew Huxley in 1952. This is a mathematical model that represents the formation of electrical activity in neurons. This model is a set of nonlinear differential equations that approximates the electrical characteristics of neurons of squid giant axon. They received Nobel Prize in Physiology or Medicine for this work in the year 1963. HH.m implements the Hodgkin Huxley model for different applied excitations (stimulus current).

Beeler and Reuter developed a model in 1977 for cardiac muscle. This model has fast inward sodium current INa, similar to Hodgkin and Huxley model. In addition, a slow gating variable (j), a time-activated outward current (Ix1), a time-independent potassium outward current (IK1), and a secondary slow inward calcium current (Is).  Plateau phase is observed in the action potential of cardiac cells which was not found in nerve cells. This is due to the inflow of calcium ions. BR.m implements the Beeler Reuter model.

O'Hara-Rudy Model:

This MATLAB code is derived from a CellML implementation of the O'Hara-Rudy Model, with modifications to facilitate the generation of cardiac action potentials. It enables the simulation of electrical activity of cardiac cells based on the O'Hara-Rudy framework.

For a more detailed understanding, refer to "Simulation of the Undiseased Human Cardiac Ventricular Action Potential: Model Formulation and Experimental Validation" by 
Thomas O'Hara, László Virág, András Varró and Yoram Rudy.

Ten Tusscher Model (2d tissue)

This initial version was a preliminary implementation of the Ten Tusscher 2004 model, using MATLAB code generated from the CellML format available on the PhysioNet repository. It represents an early attempt to extend the single-cell model into a two-dimensional tissue simulation. While the code was functional, it served primarily as a proof of concept and was subsequently refined and optimized in later versions. This code was developed to simulate an endocardial tissue model with a grid size of 100×100. It also records the simulation output as a video file named endoparallel.avi. The most recent version of the potential update is available at the following link https://github.com/HelanSatish/P535T.
