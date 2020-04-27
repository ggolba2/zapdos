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

class ComsolElectronBC;

template <>
InputParameters validParams<ComsolElectronBC>();

class ComsolElectronBC : public IntegratedBC
{
public:
  ComsolElectronBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  Real _r_units;
  Real _r;

  // Coupled variables

  const VariableGradient & _grad_potential;
  unsigned int _potential_id;
  const VariableValue & _mean_en;
  unsigned int _mean_en_id;
  std::vector<MooseVariable *> _ip_var;
  std::vector<const VariableValue *> _ip;
  std::vector<const VariableGradient *> _grad_ip;
  std::vector<unsigned int> _ip_id;

  const MaterialProperty<Real> & _muem;
  const MaterialProperty<Real> & _d_muem_d_actual_mean_en;
  const MaterialProperty<Real> & _massem;
  const MaterialProperty<Real> & _e;
  std::vector<const MaterialProperty<Real> *> _sgnip;
  std::vector<const MaterialProperty<Real> *> _muip;
  std::vector<const MaterialProperty<Real> *> _Dip;
  //const MaterialProperty<Real> & _se_coeff;
  const Real _se_coeff;

  Real _a;
  Real _v_thermal;
  RealVectorValue _ion_flux;
  Real _n_gamma;
  Real _d_v_thermal_d_u;
  Real _d_v_thermal_d_mean_en;
  RealVectorValue _d_ion_flux_d_potential;
  RealVectorValue _d_ion_flux_d_ip;
  Real _d_n_gamma_d_potential;
  Real _d_n_gamma_d_ip;
  Real _d_n_gamma_d_u;
  Real _d_n_gamma_d_mean_en;
  Real _actual_mean_en;

  std::vector<unsigned int> _ion_id;
  unsigned int _num_ions;
  unsigned int _ip_index;
  std::vector<unsigned int>::iterator _iter;
};
