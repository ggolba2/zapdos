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

#include "ADInterfaceKernel.h"

/**
 * DGKernel for enforcing a dielectric boundary condition on
 * a potential variable, including surface charge as an
 * ADMaterialProperty.
 * Jacobians computed through automatic differentiation.
 */
class ADPotentialSurfaceCharge : public ADInterfaceKernel
{
public:
  static InputParameters validParams();

  ADPotentialSurfaceCharge(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual(Moose::DGResidualType type) override;

  const Real _r_units;
  const Real _r_neighbor_units;
  const MaterialProperty<Real> & _D;
  const MaterialProperty<Real> & _D_neighbor;
  const ADMaterialProperty<Real> & _sigma;
};
