//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef DRIFTDIFFUSIONDONOTHINGELECTRONBC_H
#define DRIFTDIFFUSIONDONOTHINGELECTRONBC_H

#include "IntegratedBC.h"

class DriftDiffusionDoNothingElectronBC;

template <>
InputParameters validParams<DriftDiffusionDoNothingElectronBC>();

// This diffusion kernel should only be used with species whose values are in the logarithmic form.

class DriftDiffusionDoNothingElectronBC : public IntegratedBC
{
public:
  DriftDiffusionDoNothingElectronBC(const InputParameters & parameters);
  virtual ~DriftDiffusionDoNothingElectronBC();

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  Real _r_units;

  const MaterialProperty<Real> & _muem;
  const MaterialProperty<Real> & _d_muem_d_actual_mean_en;
  const MaterialProperty<Real> & _sign;
  const MaterialProperty<Real> & _diffem;
  const MaterialProperty<Real> & _d_diffem_d_actual_mean_en;

  unsigned int _potential_id;
  const VariableGradient & _grad_potential;
  const VariableValue & _mean_en;
  unsigned int _mean_en_id;

  Real _d_actual_mean_en_d_mean_en;
  Real _d_muem_d_mean_en;
  Real _d_actual_mean_en_d_u;
  Real _d_muem_d_u;
  Real _d_diffem_d_u;
  Real _d_diffem_d_mean_en;
};

#endif /* DRIFTDIFFUSIONDONOTHINGELECTRONBC_H */
