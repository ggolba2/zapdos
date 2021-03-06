//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "LymberopoulosIonBC.h"

// MOOSE includes
#include "MooseVariable.h"

registerMooseObject("ZapdosApp", LymberopoulosIonBC);

template <>
InputParameters
validParams<LymberopoulosIonBC>()
{
  InputParameters params = validParams<IntegratedBC>();
  params.addRequiredCoupledVar("potential", "The electric potential");
  params.addRequiredParam<Real>("position_units", "Units of position.");
  params.addClassDescription("Simpified kinetic ion boundary condition"
                             "(Based on DOI: https://doi.org/10.1063/1.352926)");
  return params;
}

LymberopoulosIonBC::LymberopoulosIonBC(const InputParameters & parameters)
  : IntegratedBC(parameters),

    _r_units(1. / getParam<Real>("position_units")),

    // Coupled Variables
    _grad_potential(coupledGradient("potential")),
    _potential_id(coupled("potential")),

    _mu(getMaterialProperty<Real>("mu" + _var.name()))
{
}

Real
LymberopoulosIonBC::computeQpResidual()
{

  return _test[_i][_qp] * _r_units * _mu[_qp] * -_grad_potential[_qp] * _r_units *
         std::exp(_u[_qp]) * _normals[_qp];
}

Real
LymberopoulosIonBC::computeQpJacobian()
{

  return _test[_i][_qp] * _r_units * _mu[_qp] * -_grad_potential[_qp] * _r_units *
         std::exp(_u[_qp]) * _phi[_j][_qp] * _normals[_qp];
}

Real
LymberopoulosIonBC::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _potential_id)
  {

    return _test[_i][_qp] * _r_units * _mu[_qp] * _grad_phi[_j][_qp] * _r_units *
           std::exp(_u[_qp]) * _normals[_qp];
  }

  else
    return 0.0;
}
