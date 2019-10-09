//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef HAGELAARENERGYBC_H
#define HAGELAARENERGYBC_H

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
  MooseVariable & _ip_var;
  //std::vector<MooseVariable *> _ip_var2;
  std::vector<const VariableValue *> _ip;
  std::vector<const VariableGradient *> _grad_ip;
  //unsigned int _ip_id;
  std::vector<unsigned int> _ip_id;

  const MaterialProperty<Real> & _muem;
  const MaterialProperty<Real> & _d_muem_d_actual_mean_en;
  const MaterialProperty<Real> & _massem;
  const MaterialProperty<Real> & _e;
  const MaterialProperty<Real> & _sgnip;
  const MaterialProperty<Real> & _muip;
  const MaterialProperty<Real> & _Dip;
  //std::vector<const MaterialProperty<Real> *> _sgnip;
  //std::vector<const MaterialProperty<Real> *> _muip;
  //std::vector<const MaterialProperty<Real> *> _Dip;
  const MaterialProperty<Real> & _se_coeff;
  const MaterialProperty<Real> & _se_energy;
  const MaterialProperty<Real> & _mumean_en;
  const MaterialProperty<Real> & _d_mumean_en_d_actual_mean_en;

  Real _a;
  Real _v_thermal;
  RealVectorValue _ion_flux;
  Real _n_gamma;
  Real _d_v_thermal_d_u;
  Real _d_v_thermal_d_em;
  RealVectorValue _d_ion_flux_d_potential;
  RealVectorValue _d_ion_flux_d_ip;
  Real _d_n_gamma_d_potential;
  Real _d_n_gamma_d_ip;
  Real _d_n_gamma_d_u;
  Real _d_n_gamma_d_em;
  Real _actual_mean_en;
  std::vector<unsigned int>::iterator _it;
  unsigned int _ip_num;
};

#endif // HAGELAARENERGYBC_H
