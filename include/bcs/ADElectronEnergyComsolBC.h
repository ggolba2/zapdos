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
class ADElectronEnergyComsolBC;

declareADValidParams(ADElectronEnergyComsolBC);

class ADElectronEnergyComsolBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();
  ADElectronEnergyComsolBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  Real _r_units;
  Real _r;

  // Coupled variables

  //const ADVariableGradient & _grad_potential;
  const ADVariableValue & _em;

  //const ADMaterialProperty<Real> & _muem;
  const MaterialProperty<Real> & _massem;
  const MaterialProperty<Real> & _e;

  Real _a;
  ADReal _v_thermal;

};
