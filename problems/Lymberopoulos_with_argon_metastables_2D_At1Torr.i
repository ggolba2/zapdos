dom0Scale=25.4e-3
#dom0Scale=1.0

[GlobalParams]
  potential_units = V
  use_moles = true
[]

[Mesh]
  type = FileMesh
  file = 'GEC_mesh.msh'
[]

[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
[]

[Variables]
  [./em]
  [../]

  [./Ar+]
  [../]

  [./Ar*]
  [../]

  [./mean_en]
  [../]

  [./potential]
  [../]

  [./potential_ion]
  [../]
[]

[Kernels]
  #Electron Equations (Same as in paper)
    #Time Derivative term of electron
    [./em_time_deriv]
      type = ElectronTimeDerivative
      variable = em
    [../]
    #Advection term of electron
    [./em_advection]
      type = EFieldAdvectionElectrons
      variable = em
      potential = potential
      mean_en = mean_en
      position_units = ${dom0Scale}
    [../]
    #Diffusion term of electrons
    [./em_diffusion]
      type = CoeffDiffusionElectrons
      variable = em
      mean_en = mean_en
      position_units = ${dom0Scale}
    [../]
    #Net electron production from ionization
    [./em_ionization]
      type = ElectronReactantSecondOrderLog
      variable = em
      v = Ar
      energy = mean_en
      reaction = 'em + Ar -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net electron production from step-wise ionization
    [./em_stepwise_ionization]
      type = ElectronReactantSecondOrderLog
      variable = em
      v = Ar*
      energy = mean_en
      reaction = 'em + Ar* -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net electron production from metastable pooling
    [./em_pooling]
      type = ProductSecondOrderLog
      variable = em
      v = Ar*
      w = Ar*
      reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
      coefficient = 1
    [../]

  #Argon Ion Equations (Same as in paper)
    #Time Derivative term of the ions
    [./Ar+_time_deriv]
      type = ElectronTimeDerivative
      variable = Ar+
    [../]
    #Advection term of ions
    [./Ar+_advection]
      type = EFieldAdvection
      variable = Ar+
      potential = potential_ion
      position_units = ${dom0Scale}
    [../]
    [./Ar+_diffusion]
      type = CoeffDiffusion
      variable = Ar+
      position_units = ${dom0Scale}
    [../]
    #Net ion production from ionization
    [./Ar+_ionization]
      type = ElectronProductSecondOrderLog
      variable = Ar+
      electron = em
      target = Ar
      energy = mean_en
      reaction = 'em + Ar -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net ion production from step-wise ionization
    [./Ar+_stepwise_ionization]
      type = ElectronProductSecondOrderLog
      variable = Ar+
      electron = em
      target = Ar*
      energy = mean_en
      reaction = 'em + Ar* -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net ion production from metastable pooling
    [./Ar+_pooling]
      type = ProductSecondOrderLog
      variable = Ar+
      v = Ar*
      w = Ar*
      reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
      coefficient = 1
    [../]

    #Argon Excited Equations (Same as in paper)
      #Time Derivative term of excited Argon
      [./Ar*_time_deriv]
        type = ElectronTimeDerivative
        variable = Ar*
      [../]
      #Diffusion term of excited Argon
      [./Ar*_diffusion]
        type = CoeffDiffusion
        variable = Ar*
        position_units = ${dom0Scale}
      [../]
      #Net excited Argon production from excitation
      [./Ar*_excitation]
        type = ElectronProductSecondOrderLog
        variable = Ar*
        electron = em
        target = Ar
        energy = mean_en
        reaction = 'em + Ar -> em + Ar*'
        coefficient = 1
      [../]
      #Net excited Argon loss from step-wise ionization
      [./Ar*_stepwise_ionization]
        type = ElectronProductSecondOrderLog
        variable = Ar*
        electron = em
        target = Ar*
        energy = mean_en
        reaction = 'em + Ar* -> em + em + Ar+'
        coefficient = -1
        _target_eq_u = true
      [../]
      #Net excited Argon loss from superelastic collisions
      [./Ar*_collisions]
        type = ElectronProductSecondOrderLog
        variable = Ar*
        electron = em
        target = Ar*
        energy = mean_en
        reaction = 'em + Ar* -> em + Ar'
        coefficient = -1
        _target_eq_u = true
      [../]
      #Net excited Argon loss from quenching to resonant
      [./Ar*_quenching]
        type = ElectronProductSecondOrderLog
        variable = Ar*
        electron = em
        target = Ar*
        energy = mean_en
        reaction = 'em + Ar* -> em + Ar_r'
        coefficient = -1
        _target_eq_u = true
      [../]
      #Net excited Argon loss from  metastable pooling
      [./Ar*_pooling]
        type = ReactantSecondOrderLog
        variable = Ar*
        v = Ar*
        reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
        coefficient = -2
        _v_eq_u = true
      [../]
      #Net excited Argon loss from two-body quenching
      [./Ar*_2B_quenching]
        type = ReactantSecondOrderLog
        variable = Ar*
        v = Ar
        reaction = 'Ar* + Ar -> Ar + Ar'
        coefficient = -1
      [../]
      #Net excited Argon loss from three-body quenching
      [./Ar*_3B_quenching]
        type = ReactantThirdOrderLog
        variable = Ar*
        v = Ar
        w = Ar
        reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
        coefficient = -1
      [../]

  #Voltage Equations (Same as in paper)
    #Voltage term in Poissons Eqaution
    [./potential_diffusion_dom0]
      type = CoeffDiffusionLin
      variable = potential
      position_units = ${dom0Scale}
    [../]
    #Ion term in Poissons Equation
    [./Ar+_charge_source]
      type = ChargeSourceMoles_KV
      variable = potential
      charged = Ar+
    [../]
    #Electron term in Poissons Equation
    [./em_charge_source]
      type = ChargeSourceMoles_KV
      variable = potential
      charged = em
    [../]


  #Since the paper uses electron temperature as a variable, the energy equation is in
  #a different form but should be the same physics
    #Time Derivative term of electron energy
    [./mean_en_time_deriv]
      type = ElectronTimeDerivative
      variable = mean_en
    [../]
    #Advection term of electron energy
    [./mean_en_advection]
      type = EFieldAdvectionEnergy
      variable = mean_en
      potential = potential
      em = em
      position_units = ${dom0Scale}
    [../]
    #Diffusion term of electrons energy
    [./mean_en_diffusion]
      type = CoeffDiffusionEnergy
      variable = mean_en
      em = em
      position_units = ${dom0Scale}
    [../]
    #Joule Heating term
    [./mean_en_joule_heating]
      type = JouleHeating
      variable = mean_en
      potential = potential
      em = em
      position_units = ${dom0Scale}
    [../]
    #Energy loss from ionization
    [./Ionization_Loss]
      type = ElectronEnergyTermRate
      variable = mean_en
      em = em
      v = Ar
      reaction = 'em + Ar -> em + em + Ar+'
      threshold_energy = -15.7
      position_units = ${dom0Scale}
    [../]
    #Energy loss from excitation
    [./Excitation_Loss]
      type = ElectronEnergyTermRate
      variable = mean_en
      em = em
      v = Ar
      reaction = 'em + Ar -> em + Ar*'
      threshold_energy = -11.56
      position_units = ${dom0Scale}
    [../]
    #Energy loss from step-wise ionization
    [./Stepwise_Ionization_Loss]
      type = ElectronEnergyTermRate
      variable = mean_en
      em = em
      v = Ar*
      reaction = 'em + Ar* -> em + em + Ar+'
      threshold_energy = -4.14
      position_units = ${dom0Scale}
    [../]
    #Energy gain from superelastic collisions
    [./Collisions_Loss]
      type = ElectronEnergyTermRate
      variable = mean_en
      em = em
      v = Ar*
      reaction = 'em + Ar* -> em + Ar'
      threshold_energy = 11.56
      position_units = ${dom0Scale}
    [../]
    #Energy loss from elastic collisions
    [./Elastic_Loss]
      type = ElectronEnergyTermElasticRate
      variable = mean_en
      electron_species = em
      target_species = Ar
      potential = potential
      reaction = 'em + Ar -> em + Ar'
      position_units = ${dom0Scale}
    [../]

    #Effective potential for the Ions
    [./Ion_potential_time_deriv]
      type = TimeDerivative
      variable = potential_ion
    [../]
    [./Ion_potential_reaction]
      type = ScaledReaction
      variable = potential_ion
      collision_freq = 12833708.75
    [../]
    [./Ion_potential_coupled_force]
      type = CoupledForce
      variable = potential_ion
      v = potential
      coef = 12833708.75
    [../]
  []


[AuxVariables]
  [./emDeBug]
  [../]
  [./Ar+_DeBug]
  [../]
  [./Ar*_DeBug]
  [../]
  [./mean_enDeBug]
  [../]
  [./potential_DeBug]
  [../]

  [./Te]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./x_node]
  [../]

  [./y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./y_node]
  [../]

  [./rho]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./em_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar+_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar*_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar]
  [../]

  [./Efieldx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Efieldy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Current_em]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./Current_Ar]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./emRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./exRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./swRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./deexRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./quRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./poolRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./TwoBRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]
  [./ThreeBRate]
    order = CONSTANT
    family = MONOMIAL
    block = 'plasma'
  [../]

[]

[AuxKernels]
  #[./emDeBug]
  #  type = DebugResidualAux
  #  variable = emDeBug
  #  debug_variable = em
  #[../]
  #[./Ar+_DeBug]
  #  type = DebugResidualAux
  #  variable = Ar+_DeBug
  #  debug_variable = Ar+
  #[../]
  #[./mean_enDeBug]
  #  type = DebugResidualAux
  #  variable = mean_enDeBug
  #  debug_variable = mean_en
  #[../]
  #[./Ar*_DeBug]
  #  type = DebugResidualAux
  #  variable = Ar*_DeBug
  #  debug_variable = Ar*
  #[../]
  #[./Potential_DeBug]
  #  type = DebugResidualAux
  #  variable = potential_DeBug
  #  debug_variable = potential
  #[../]

  [./emRate]
    type = ProcRateForRateCoeff
    variable = emRate
    v = em
    w = Ar
    reaction = 'em + Ar -> em + em + Ar+'
  [../]
  [./exRate]
    type = ProcRateForRateCoeff
    variable = exRate
    v = em
    w = Ar*
    reaction = 'em + Ar -> em + Ar*'
  [../]
  [./swRate]
    type = ProcRateForRateCoeff
    variable = swRate
    v = em
    w = Ar*
    reaction = 'em + Ar* -> em + em + Ar+'
  [../]
  [./deexRate]
    type = ProcRateForRateCoeff
    variable = deexRate
    v = em
    w = Ar*
    reaction = 'em + Ar* -> em + Ar'
  [../]
  [./quRate]
    type = ProcRateForRateCoeff
    variable = quRate
    v = em
    w = Ar*
    reaction = 'em + Ar* -> em + Ar_r'
  [../]
  [./poolRate]
    type = ProcRateForRateCoeff
    variable = poolRate
    v = Ar*
    w = Ar*
    reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
  [../]
  [./TwoBRate]
    type = ProcRateForRateCoeff
    variable = TwoBRate
    v = Ar*
    w = Ar
    reaction = 'Ar* + Ar -> Ar + Ar'
  [../]
  [./ThreeBRate]
    type = ProcRateForRateCoeffThreeBody
    variable = ThreeBRate
    v = Ar*
    w = Ar
    vv = Ar
    reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
  [../]
  [./Te]
    type = ElectronTemperature
    variable = Te
    electron_density = em
    mean_en = mean_en
  [../]
  [./x_g]
    type = Position
    variable = x
    position_units = ${dom0Scale}
  [../]
  [./x_ng]
    type = Position
    variable = x_node
    position_units = ${dom0Scale}
  [../]

  [./y_g]
    type = Position
    variable = y
    position_units = ${dom0Scale}
  [../]
  [./y_ng]
    type = Position
    variable = y_node
    position_units = ${dom0Scale}
  [../]

  [./em_lin]
    type = DensityMoles
    convert_moles = true
    variable = em_lin
    density_log = em
  [../]
  [./Ar+_lin]
    type = DensityMoles
    convert_moles = true
    variable = Ar+_lin
    density_log = Ar+
  [../]
  [./Ar*_lin]
    type = DensityMoles
    convert_moles = true
    variable = Ar*_lin
    density_log = Ar*
  [../]

  [./Ar_val]
    type = ConstantAux
    variable = Ar
    # value = 3.22e22
    value = -2.928623
    execute_on = INITIAL
  [../]

  [./Efieldx_calc]
    type = Efield
    component = 0
    potential = potential
    variable = Efieldx
    position_units = ${dom0Scale}
  [../]
  [./Efieldy_calc]
    type = Efield
    component = 1
    potential = potential
    variable = Efieldy
    position_units = ${dom0Scale}
  [../]

  [./Current_em]
    type = Current
    potential = potential
    density_log = em
    variable = Current_em
    art_diff = false
    block = 'plasma'
    position_units = ${dom0Scale}
  [../]
  [./Current_Ar]
    type = Current
    potential = potential_ion
    density_log = Ar+
    variable = Current_Ar
    art_diff = false
    block = 'plasma'
    position_units = ${dom0Scale}
  [../]

[]


[BCs]
#Voltage Boundary Condition, same as in paper
  [./potential_top_plate]
    type = FunctionDirichletBC
    variable = potential
    boundary = 'Top_Electrode'
    function = potential_top_bc_func
  [../]
  [./potential_bottom_plate]
    type = FunctionDirichletBC
    variable = potential
    boundary = 'Bottom_Electrode'
    function = potential_bottom_bc_func
  [../]
  [./potential_dirichlet_bottom_plate]
    type = DirichletBC
    variable = potential
    boundary = 'Walls'
    value = 0
  [../]
  [./potential_Dielectric]
    type = EconomouDielectricBC
    variable = potential
    boundary = 'Top_Insulator Bottom_Insulator'
    em = em
    ip = Ar+
    potential_ion = potential_ion
    mean_en = mean_en
    dielectric_constant = 1.859382e-11
    thickness = 0.0127
    users_gamma = 0.01
    position_units = ${dom0Scale}
  [../]


#New Boundary conditions for electons, same as in paper
  [./em_physical_diffusion]
    type = SakiyamaElectronDiffusionBC
    variable = em
    mean_en = mean_en
    boundary = 'Top_Electrode Bottom_Electrode Top_Insulator Bottom_Insulator Walls'
    position_units = ${dom0Scale}
  [../]
  [./em_Ar+_second_emissions]
    type = SakiyamaSecondaryElectronBC
    variable = em
    mean_en = mean_en
    potential = potential_ion
    ip = Ar+
    users_gamma = 0.01
    boundary = 'Top_Electrode Bottom_Electrode Top_Insulator Bottom_Insulator Walls'
    position_units = ${dom0Scale}
    neutral_gas = Ar
  [../]

#New Boundary conditions for ions, should be the same as in paper
  [./Ar+_physical_advection]
    type = SakiyamaIonAdvectionBC
    variable = Ar+
    potential = potential_ion
    boundary = 'Top_Electrode Bottom_Electrode Top_Insulator Bottom_Insulator Walls'
    position_units = ${dom0Scale}
  [../]

#New Boundary conditions for ions, should be the same as in paper
#(except the metastables are not set to zero, since Zapdos uses log form)
  [./Ar*_physical_diffusion]
    type = LogDensityDirichletBC
    variable = Ar*
    boundary = 'Top_Electrode Bottom_Electrode Top_Insulator Bottom_Insulator Walls'
    value = 100
  [../]

#New Boundary conditions for mean energy, should be the same as in paper
[./mean_en_physical_diffusion]
  type = SakiyamaEnergyDiffusionBC
  variable = mean_en
  em = em
  boundary = 'Top_Electrode Bottom_Electrode Top_Insulator Bottom_Insulator Walls'
  position_units = ${dom0Scale}
[../]
[./mean_en_Ar+_second_emissions]
  type = SakiyamaEnergySecondaryElectronBC
  variable = mean_en
  em = em
  ip = Ar+
  potential = potential_ion
  Tse_equal_Te = true
  se_coeff = 0.01
  boundary = 'Top_Electrode Bottom_Electrode Top_Insulator Bottom_Insulator Walls'
  position_units = ${dom0Scale}
[../]

[]


[ICs]
  [./em_ic]
    type = FunctionIC
    variable = em
    function = density_ic_func
  [../]
  [./Ar+_ic]
    type = FunctionIC
    variable = Ar+
    function = density_ic_func
  [../]
  [./Ar*_ic]
    type = FunctionIC
    variable = Ar*
    function = meta_density_ic_func
  [../]
  [./mean_en_ic]
    type = FunctionIC
    variable = mean_en
    function = energy_density_ic_func
  [../]

  [./potential_ic]
    type = FunctionIC
    variable = potential
    function = potential_ic_func
  [../]
[]

[Functions]
  [./potential_top_bc_func]
    type = ParsedFunction
    value = '30*sin(2*3.1415926*13.56e6*t)'
  [../]
  [./potential_bottom_bc_func]
    type = ParsedFunction
    value = '-30*sin(2*3.1415926*13.56e6*t)'
  [../]
  [./potential_ic_func]
    type = ParsedFunction
    value = 0
  [../]
  [./density_ic_func]
    type = ParsedFunction
    value = 'log((1e14)/6.022e23)'
  [../]
  [./meta_density_ic_func]
    type = ParsedFunction
    value = 'log((1e16)/6.022e23)'
  [../]
  [./energy_density_ic_func]
    type = ParsedFunction
    value = 'log((3./2.)) + log((1e14)/6.022e23)'
  [../]
[]

[Materials]
  [./GasBasics]
    type = GasElectronMoments
    interp_trans_coeffs = true
    interp_elastic_coeff = false
    ramp_trans_coeffs = false
    user_p_gas = 133.322
    em = em
    potential = potential
    mean_en = mean_en
    user_se_coeff = 0.00
    property_tables_file = Argon_reactions_paper_RateCoefficients_1Torr/electron_moments.txt
    position_units = ${dom0Scale}
  [../]
  [./gas_species_0]
    type = HeavySpeciesMaterial
    heavy_species_name = Ar+
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 1.0
    mobility = 0.144409938
    diffusivity = 6.428571e-3
  [../]
  [./gas_species_1]
    type = HeavySpeciesMaterial
    heavy_species_name = Ar*
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
    diffusivity = 7.515528e-3
  [../]
  [./gas_species_2]
    type = HeavySpeciesMaterial
    heavy_species_name = Ar
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
  [../]
  [./reaction_00]
    type = ZapdosEEDFRateConstant
    mean_en = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients_1Torr/reaction_em + Ar -> em + Ar.txt'
    reaction = 'em + Ar -> em + Ar'
    position_units = ${dom0Scale}
    file_location = ''
    em = em
  [../]
  [./reaction_0]
    type = ZapdosEEDFRateConstant
    mean_en = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients_1Torr/reaction_em + Ar -> em + Ar*.txt'
    reaction = 'em + Ar -> em + Ar*'
    position_units = ${dom0Scale}
    file_location = ''
    em = em
  [../]
  [./reaction_1]
    type = ZapdosEEDFRateConstant
    mean_en = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients_1Torr/reaction_em + Ar -> em + em + Ar+.txt'
    reaction = 'em + Ar -> em + em + Ar+'
    position_units = ${dom0Scale}
    file_location = ''
    em = em
  [../]
  [./reaction_2]
    type = ZapdosEEDFRateConstant
    mean_en = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients_1Torr/reaction_em + Ar* -> em + Ar.txt'
    reaction = 'em + Ar* -> em + Ar'
    position_units = ${dom0Scale}
    file_location = ''
    em = em
  [../]
  [./reaction_3]
    type = ZapdosEEDFRateConstant
    mean_en = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients_1Torr/reaction_em + Ar* -> em + em + Ar+.txt'
    reaction = 'em + Ar* -> em + em + Ar+'
    position_units = ${dom0Scale}
    file_location = ''
    em = em
  [../]
  [./reaction_4]
    type = GenericRateConstant
    reaction = 'em + Ar* -> em + Ar_r'
    #reaction_rate_value = 2e-13
    reaction_rate_value = 1.2044e11
  [../]
  [./reaction_5]
    type = GenericRateConstant
    reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
    #reaction_rate_value = 6.2e-16
    reaction_rate_value = 373364000
  [../]
  [./reaction_6]
    type = GenericRateConstant
    reaction = 'Ar* + Ar -> Ar + Ar'
    #reaction_rate_value = 3e-21
    reaction_rate_value = 1806.6
  [../]
  [./reaction_7]
    type = GenericRateConstant
    reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
    #reaction_rate_value = 1.1e-42
    reaction_rate_value = 398909.324
  [../]
[]

#New postprocessor that calculates the inverse of the plasma frequency
[Postprocessors]
  [./InversePlasmaFreq]
    type = PlasmaFrequencyInverse
    variable = em
    use_moles = true
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  [../]
[]


[Preconditioning]
  active = 'smp'
  [./smp]
    type = SMP
    full = true
  [../]

  [./fdp]
    type = FDP
    full = true
  [../]
[]


[Executioner]
  type = Transient
  end_time = 7.4e-3
  automatic_scaling = true
  dtmax = 1e-9
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'
  nl_rel_tol = 1e-8
  #nl_abs_tol = 7.6e-5
  dtmin = 1e-14
  l_max_its = 20

  #Time steps based on the inverse of the plasma frequency
  #[./TimeStepper]
  #  type = PostprocessorDT
  #  postprocessor = InversePlasmaFreq
  #  scale = 0.1
  #[../]
[]

[Outputs]
  perf_graph = true
  [./out]
    type = Exodus
  [../]
[]
