//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADNodalBC.h"
#include "MooseVariable.h"


class H2OTempBC : public ADNodalBC
{
public:
  static InputParameters validParams();

  H2OTempBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;
  //ADReal computeQpValue();
  const ADVariableValue & _gas_temp;
  ADReal _vapor_pressure;
  ADReal _atoms_H2O;
  ADReal _units_H2O;



};
