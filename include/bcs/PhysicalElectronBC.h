#ifndef PHYSICALELECTRONBC_H
#define PHYSICALELECTRONBC_H

#include "IntegratedBC.h"

class PhysicalElectronBC;

template<>
InputParameters validParams<PhysicalElectronBC>();

class PhysicalElectronBC : public IntegratedBC
{
public:

  PhysicalElectronBC(const std::string & name, InputParameters parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  // Input Parameters

  const Real & _reflection_coeff;
  const Real & _se_coeff;

  // Members unique to class  

  Real _a;
  Real _a_p;
  Real _n_gamma;
  
  // Material Properties

  MaterialProperty<RealVectorValue> & _advection_velocity_em;
  MaterialProperty<Real> & _muem;
  MaterialProperty<Real> & _v_thermal_em;
  MaterialProperty<RealVectorValue> & _gamma_ip;
  MaterialProperty<RealVectorValue> & _advection_velocity_ip;
  MaterialProperty<Real> & _muip;

  // Coupled variables
  
  VariableValue & _ip;
};

#endif //PHYSICALELECTRONBC_H