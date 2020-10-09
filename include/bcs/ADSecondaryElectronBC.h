//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADIntegratedBC.h"

// Forward Declarations
class ADSecondaryElectronBC;

declareADValidParams(ADSecondaryElectronBC);

class ADSecondaryElectronBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();
  ADSecondaryElectronBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  Real _r_units;
  Real _r;
  Real _r_ion;
  const MaterialProperty<Real> & _kb;

  // Coupled variables

  const ADVariableGradient & _grad_potential;
  const ADVariableValue & _mean_en;
  std::vector<const ADVariableValue *> _ip;

  const ADMaterialProperty<Real> & _muem;
  const MaterialProperty<Real> & _massem;
  const MaterialProperty<Real> & _e;
  std::vector<const MaterialProperty<Real> *> _sgnip;
  std::vector<const ADMaterialProperty<Real> *> _muip;
  std::vector<const ADMaterialProperty<Real> *> _Tip;
  std::vector<const MaterialProperty<Real> *> _massip;
  const MaterialProperty<Real> & _se_coeff;

  Real _a;
  Real _b;
  ADReal _v_thermal;
  ADReal _ion_flux;
  ADReal _n_gamma;

  unsigned int _num_ions;
};
