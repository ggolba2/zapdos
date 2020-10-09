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

#include "IntegratedBC.h"

class HagelaarEnergyBC;

template <>
InputParameters validParams<HagelaarEnergyBC>();

class HagelaarEnergyBC : public IntegratedBC
{
public:
  HagelaarEnergyBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  Real _r_units;
  Real _r;

  // Coupled variables

  const VariableGradient & _grad_potential;
  unsigned int _potential_id;
  const VariableValue & _em;
  unsigned int _em_id;

  const MaterialProperty<Real> & _massem;
  const MaterialProperty<Real> & _e;
  const MaterialProperty<Real> & _mumean_en;
  const MaterialProperty<Real> & _d_mumean_en_d_actual_mean_en;

  Real _a;
  Real _v_thermal;
  Real _d_v_thermal_d_u;
  Real _d_v_thermal_d_em;
  Real _actual_mean_en;
};
