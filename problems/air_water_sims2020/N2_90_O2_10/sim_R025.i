dom0Scale=1.0
dom1Scale=1.0

[GlobalParams]
  #offset = 20
  #offset = 24
  #offset = 48
  offset = 20
  # offset = 0
  potential_units = kV
  use_moles = true
  # potential_units = V
[]

[Mesh]
  [./geo]
    type = FileMeshGenerator
    #file = 'test_001um.msh'
    file = 'mesh_10um.msh'
  [../]

  [./interface1]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '0'
    paired_block = '1'
    new_boundary = 'gas_right'
    input = geo
  [../]
  [./interface2]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '1'
    paired_block = '0'
    new_boundary = 'water_left'
    input = interface1
  [../]

  # The next two definitions create boundary conditions named
  # 'left' and 'right', where 'left' is at x = 0 and 'right' is at x = 1.1 mm.
  [./left]
    type = SideSetsFromNormalsGenerator
    normals = '-1 0 0'
    new_boundary = 'left'
    input = interface2
  [../]
  [./right]
    type = SideSetsFromNormalsGenerator
    normals = '1 0 0'
    new_boundary = 'right'
    input = left
  [../]
[]

[Problem]
  type = FEProblem
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  end_time = 1e6
  automatic_scaling = true
  compute_scaling_once = false
  #resid_vs_jac_scaling_param = 1
  line_search = 'basic'
  petsc_options = '-snes_converged_reason'
  solve_type = newton
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -snes_stol'
  petsc_options_value = 'lu NONZERO 1.e-10 0'
  #petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -sub_pc_factor_shift_type -pc_factor_shift_amount'
  #petsc_options_value = 'asm 3 ilu NONZERO 1.e-10'
  nl_rel_tol = 1e-6
  nl_div_tol = 1e5
  #nl_abs_tol = 1e-8
  dtmin = 1e-17
  l_max_its = 100
  nl_max_its = 20
  steady_state_detection = true
  steady_state_tolerance = 1e-8
  [./TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    dt = 1e-15
    growth_factor = 1.4
    optimal_iterations = 10
  [../]
[]

[Outputs]
  [out_01]
    type = Exodus
    interval = 4
    output_final = true
  [../]
[]

[Debug]
  #show_var_residual_norms = true
[]

[UserObjects]
  [./data_provider]
    type = ProvideMobility
    e = 1.6e-19
    electrode_area = 5.02e-7 # Formerly 3.14e-6
    #ballast_resist = 1e6
    #ballast_resist = 9.0e5
    #ballast_resist = 8.5e5
    #ballast_resist = 7.0e5
    #ballast_resist = 5.5e5
    #ballast_resist = 4.0e5
    #ballast_resist = 3.5e5
    ballast_resist = 2.5e5
    #ballast_resist = 2.0e5
    #ballast_resist = 1.5e5
    #ballast_resist = 1.0e5
  [../]
[]

[DriftDiffusionActionAD]
  [./Plasma]
    electrons = em
    charged_particle = 'N2p N4p Np O2p O2m Om H2Op OHp OHm Hp'
    #Neutrals = 'H2O N2v N2s N2ss N2sss N Ns O2s O Os OH OHs H2 H Hs O3 HO2 H2O2 NO NO2 N2O NO3 N2O3 N2O4 N2O5' 
    Neutrals = 'H2O N2s N2ss N2sss N Ns O2s O Os OH H2 H Hs O3 HO2 H2O2 NO NO2 N2O NO3 N2O3 N2O4 N2O5' 
    mean_energy = mean_en
    potential = potential
    is_potential_unique = false
    using_offset = true
    offset = 30
    use_ad = true
    position_units = ${dom0Scale}
    block = 0
  [../]

  [./Water]
    #charged_particle = 'em_aq OHm_aq H3Op_aq O2m_aq Om_aq HO2m_aq H2Op_aq O3m_aq NO2m_aq NO3m_aq OONOm_aq'
    #Neutrals = 'H_aq OH_aq H2O2_aq O2_aq O_aq H2_aq HO2_aq O3_aq HO3_aq NO_aq NO2_aq NO3_aq HNO2_aq HNO3_aq HOONO_aq N2O3_aq N2O4_aq N2O5_aq'
    charged_particle = 'em_aq OHm_aq H3Op_aq O2m_aq Om_aq HO2m_aq H2Op_aq O3m_aq NO2m_aq NO3m_aq'
    Neutrals = 'H_aq OH_aq H2O2_aq O2_aq O_aq H2_aq HO2_aq O3_aq HO3_aq NO_aq NO2_aq NO3_aq HNO2_aq HNO3_aq N2O3_aq N2O4_aq N2O5_aq'
    is_potential_unique = false
    potential = potential
    using_offset = true
    offset = 30
    use_ad = true
    position_units = ${dom1Scale}
    block = 1
  [../]
[]

[Variables]
  [./potential]
  [../]

  ###########################
  # GAS SPECIES
  ###########################
  [H2O]
    block = 0
  []
  [./em_aq]
    block = 1
    initial_condition = -16
  [../]
  [Hp]
    block = 0
    initial_condition = -30
  []
  #[./Na+]
  #  block = 1
  #  initial_condition = 4.60517
  #[../]
  #[./Cl-]
  #  block = 1
  #  initial_condition = 4.60517
  #[../]
  [./em]
    block = 0
    initial_condition = -24
  [../]

  # IONS
  [N2p]
    block = 0
    initial_condition = -24
  []
  [N4p]
    block = 0
    initial_condition = -30
  []
  [Np]
    block = 0
    initial_condition = -30
  []
  [O2p]
    block = 0
    initial_condition = -30
  []
  [O2m]
    block = 0
    initial_condition = -30
  []
  [Om]
    block = 0
    initial_condition = -30
  []
  [H2Op]
    block = 0
    initial_condition = -30
  []
  [OHp]
    block = 0
    initial_condition = -30
  []
  [OHm]
    block = 0
    initial_condition = -30
  []

  # NEUTRALS
  #[N2v]
  #  block = 0
  #  initial_condition = -30
  #[]
  [N2s]
    block = 0
    initial_condition = -30
  []
  [N2ss]
    block = 0
    initial_condition = -30
  []
  [N2sss]
    block = 0
    initial_condition = -30
  []
  [N]
    block = 0
    initial_condition = -30
  []
  [Ns]
    block = 0
    initial_condition = -30
  []
  [O2s]
    block = 0
    initial_condition = -30
  []
  [O]
    block = 0
    initial_condition = -30
  []
  [Os]
    block = 0
    initial_condition = -30
  []
  [OH]
    block = 0
    initial_condition = -30
  []
  #[OHs]
  #  block = 0
  #  initial_condition = -30
  #[]
  [H2]
    block = 0
    initial_condition = -30
  []
  [H]
    block = 0
    initial_condition = -30
  []
  [Hs]
    block = 0
    initial_condition = -30
  []
  [O3]
    block = 0
    initial_condition = -30
  []
  [HO2]
    block = 0
    initial_condition = -30
  []
  [H2O2]
    block = 0
    initial_condition = -30
  []
  [NO]
    block = 0
    initial_condition = -30
  []
  [NO2]
    block = 0
    initial_condition = -30
  []
  [N2O]
    block = 0
    initial_condition = -30
  []
  [NO3]
    block = 0
    initial_condition = -30
  []
  [N2O3]
    block = 0
    initial_condition = -30
  []
  [N2O4]
    block = 0
    initial_condition = -30
  []
  [N2O5]
    block = 0
    initial_condition = -30
  []

  [./mean_en]
    block = 0
    initial_condition = -24
    # scaling = 1e-1
  [../]

  #[./O2_aq]
  #  block = 1
  #  #initial_condition = -0.609203
  #  initial_condition = -24
  #[../]

  [./OHm_aq]
    block = 1
    # scaling = 1e-5
    #initial_condition = -24
    #initial_condition = -21
    #initial_condition = -9.210340
    initial_condition = -14
  [../]

  #[./O3]
  #  block = 1
  #  initial_condition = -31
  #[../]
  #
  #[./H]
  #  block = 1
  #  initial_condition = -25
  #[../]
  #
  #[./H2]
  #  block = 1
  #  initial_condition = -31
  #[../]
  #
  #[./HO2]
  #  block = 1
  #  initial_condition = -31
  #[../]
  #
  [./OH_aq]
    block = 1
    initial_condition = -25
  [../]

  [./H3Op_aq]
    block = 1
    initial_condition = -14
  [../]
  [./O2m_aq]
    block = 1
    initial_condition = -20
  [../]
  [./HO2m_aq]
    block = 1
    initial_condition = -20
  [../]
  [./H2Op_aq]
    block = 1
    initial_condition = -20
  [../]
  [./O3m_aq]
    block = 1
    initial_condition = -20
  [../]
  [./H_aq]
    block = 1
    initial_condition = -20
  [../]
  [./H2O2_aq]
    block = 1
    initial_condition = -20
  [../]
  [./O2_aq]
    block = 1
    initial_condition = -20
  [../]
  [./O_aq]
    block = 1
    initial_condition = -20
  [../]
  [./H2_aq]
    block = 1
    initial_condition = -20
  [../]
  [./HO2_aq]
    block = 1
    initial_condition = -20
  [../]
  [./HO3_aq]
    block = 1
    initial_condition = -20
  [../]
  [./O3_aq]
    block = 1
    initial_condition = -20
  [../]
  [./Om_aq]
    block = 1
    initial_condition = -20
  [../]
  [NO2m_aq]
    block = 1
    initial_condition = -20
  []
  [NO3m_aq]
    block = 1
    initial_condition = -20
  []
  #[OONOm_aq]
  #  block = 1
  #  initial_condition = -20
  #[]
  [NO_aq]
    block = 1
    initial_condition = -20
  []
  [NO2_aq]
    block = 1
    initial_condition = -20
  []
  [NO3_aq]
    block = 1
    initial_condition = -20
  []
  [HNO2_aq]
    block = 1
    initial_condition = -20
  []
  [HNO3_aq]
    block = 1
    initial_condition = -20
  []
  #[HOONO_aq]
  #  block = 1
  #  initial_condition = -20
  #[]
  [N2O3_aq]
    block = 1
    initial_condition = -20
  []
  [N2O4_aq]
    block = 1
    initial_condition = -20
  []
  [N2O5_aq]
    block = 1
    initial_condition = -20
  []
[]

[AuxVariables]
  [./N2]
    block = 0
    order = CONSTANT
    family = MONOMIAL
    #initial_condition = 3.701920755421197
    #initial_condition = 3.6918704  # 99% N2,  1% O2
    initial_condition = 3.5965602  # 90% N2, 10% O2
    #initial_condition = 3.4787772  # 80% N2, 20% O2
    #initial_condition = 3.3308363  # 71% N2, 29% O2
    #initial_condition = 
  [../]
  [./O2]
    block = 0
    order = CONSTANT
    family = MONOMIAL
    #initial_condition = 3.701920755421197
    #initial_condition = -0.903249 # 99% N2,  1% O2
    initial_condition = 1.3993356 # 90% N2, 10% O2
    #initial_condition = 2.0924828  # 80% N2, 20% O2
    #initial_condition = 2.4640256 # 71% N2, 29% O2
    #initial_condition = 
  [../]

  [./H2O_aq]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 10.92252
    block = 1
  [../]

  [Te]
    block = 0
    order  = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  []
  [./x]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  [../]
  [./x_node]
    initial_condition = 0
  [../]
  [./rho]
    order = CONSTANT
    family = MONOMIAL
    block = 0
    initial_condition = 0
  [../]
  [./rholiq]
    block = 1
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  [../]
  [./Efield]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  [../]
  [./Current_em]
    order = CONSTANT
    family = MONOMIAL
    block = 0
    initial_condition = 0
  [../]
  [./Current_em_aq]
    order = CONSTANT
    family = MONOMIAL
    block = 1
    initial_condition = 0
  [../]
  [./Current_OHm_aq]
    block = 1
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  [../]
  [./tot_gas_current]
    order = CONSTANT
    family = MONOMIAL
    block = 0
    initial_condition = 0
  [../]
  [./tot_liq_current]
    block = 1
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  [../]
[]

[AuxKernels]
  [e_temp]
    type = ElectronTemperature
    variable = Te
    electron_density = em
    execute_on = 'initial timestep_end'
    mean_en = mean_en
    block = 0
  []
  [./x_g]
    type = Position
    variable = x
    position_units = ${dom0Scale}
    execute_on = 'initial timestep_end'
    block = 0
  [../]
  [./x_l]
    type = Position
    variable = x
    position_units = ${dom1Scale}
    execute_on = 'initial timestep_end'
    block = 1
  [../]
  [./x_ng]
    type = Position
    variable = x_node
    position_units = ${dom0Scale}
    execute_on = 'initial timestep_end'
    block = 0
  [../]
  [./x_nl]
    type = Position
    variable = x_node
    position_units = ${dom1Scale}
    execute_on = 'initial timestep_end'
    block = 1
  [../]
  [rho_calc]
    type = ChargeDensity
    variable = rho
    #charged = 'em N2p N4p Np O2p O2m Om H2Op OHp OHm'
    charged = 'em N2p N4p Np O2p O2m Om H2Op OHp OHm Hp'
    execute_on = 'INITIAL TIMESTEP_END'
    block = 0
  []
  [rholiq_calc]
    type = ChargeDensity
    variable = rholiq
    #charged = 'em_aq OH- H2O+ O- H3O+ HO2- O2- O3- H+ Na+ Cl-'
    #charged = 'em_aq OHm_aq'
    #charged = 'em_aq OHm_aq H3Op_aq O2m_aq Om_aq HO2m_aq H2Op_aq O3m_aq NO2m_aq NO3m_aq OONOm_aq'
    charged = 'em_aq OHm_aq H3Op_aq O2m_aq Om_aq HO2m_aq H2Op_aq O3m_aq NO2m_aq NO3m_aq'
    execute_on = 'INITIAL TIMESTEP_END'
    block = 1
  []
  [./Efield_g]
    type = Efield
    component = 0
    potential = potential
    variable = Efield
    position_units = ${dom0Scale}
    block = 0
  [../]
  [./Efield_l]
    type = Efield
    component = 0
    #potential = potential_liq
    potential = potential
    variable = Efield
    position_units = ${dom1Scale}
    block = 1
  [../]
  [./ADCurrent_em]
    type = ADCurrent
    potential = potential
    density_log = em
    variable = Current_em
    art_diff = false
    block = 0
    position_units = ${dom0Scale}
  [../]
  [./ADCurrent_em_aq]
    type = ADCurrent
    potential = potential
    density_log = em_aq
    variable = Current_em_aq
    art_diff = false
    block = 1
    position_units = ${dom1Scale}
  [../]
  [./ADCurrent_OHm_aq]
    block = 1
    type = ADCurrent
    #potential = potential_liq
    potential = potential
    density_log = OHm_aq
    variable = Current_OHm_aq
    art_diff = false
    position_units = ${dom1Scale}
  [../]
[]

[InterfaceKernels]
  [./em_advection]
    type = ADInterfaceAdvection
    potential_neighbor = potential
    neighbor_var = em
    variable = em_aq
    boundary = water_left
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
  [../]
  [./em_diffusion]
    #type = InterfaceLogDiffusionElectrons
    type = ADInterfaceLogDiffusion
    neighbor_var = em
    variable = em_aq
    boundary = water_left
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
  [../]

  # Henry coefficients (From Lietz, 2016)
  # H2O2  -  1.92e6
  # HO2   -  1.32e5
  # OH    -  6.2e2
  # H     -  6.48e3
  # H2    -  1.8e-2
  # O     -  1
  # O2    -  3.24e-2
  # O3    -  3e-1
  # N2    -  1.6e-2
  # N2O3  -  6.0e2
  # N2O4  -  3.69e1
  # N2O5  -  4.85e1
  # N2O   -  5.99e-1
  # HO2NO2 - 2.99e5
  # NO    -  4.4e-2
  # NO2   -  2.8e-1
  # NO3   -  4.15e1
  # HNO2, HNO  - 1.15e3
  # HNO3, ONOOH - 4.8e6
  # CO, CO(v)  - 2.42e-2
  # CO2, CO2(v)  - 8.23e-1
  # NH        - 1.47e3

  [OH_diff]
    type = InterfaceDiffusionTest
    variable = OH_aq
    neighbor_var = OH
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [OH_henry]
    type = InterfaceReactionTest
    variable = OH_aq
    neighbor_var = OH
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 6.2e2 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [H2O2_diff]
    type = InterfaceDiffusionTest
    variable = H2O2_aq
    neighbor_var = H2O2
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [H2O2_henry]
    type = InterfaceReactionTest
    variable = H2O2_aq
    neighbor_var = H2O2
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 1.92e6 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [HO2_diff]
    type = InterfaceDiffusionTest
    variable = HO2_aq
    neighbor_var = HO2
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [HO2_henry]
    type = InterfaceReactionTest
    variable = HO2_aq
    neighbor_var = HO2
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 1.32e5 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []


  [H_diff]
    type = InterfaceDiffusionTest
    variable = H_aq
    neighbor_var = H
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [H_henry]
    type = InterfaceReactionTest
    variable = H_aq
    neighbor_var = H
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [H2_diff]
    type = InterfaceDiffusionTest
    variable = H2_aq
    neighbor_var = H2
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [H2_henry]
    type = InterfaceReactionTest
    variable = H2_aq
    neighbor_var = H2
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 1.8e-2 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [O_diff]
    type = InterfaceDiffusionTest
    variable = O_aq
    neighbor_var = O
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [O_henry]
    type = InterfaceReactionTest
    variable = O_aq
    neighbor_var = O
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 1 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [O3_diff]
    type = InterfaceDiffusionTest
    variable = O3_aq
    neighbor_var = O3
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [O3_henry]
    type = InterfaceReactionTest
    variable = O3_aq
    neighbor_var = O3
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 3e-1 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [N2O3_diff]
    type = InterfaceDiffusionTest
    variable = N2O3_aq
    neighbor_var = N2O3
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [N2O3_henry]
    type = InterfaceReactionTest
    variable = N2O3_aq
    neighbor_var = N2O3
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 6e2 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [N2O4_diff]
    type = InterfaceDiffusionTest
    variable = N2O4_aq
    neighbor_var = N2O4
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [N2O4_henry]
    type = InterfaceReactionTest
    variable = N2O4_aq
    neighbor_var = N2O4
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 3.69e1 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [N2O5_diff]
    type = InterfaceDiffusionTest
    variable = N2O5_aq
    neighbor_var = N2O5
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [N2O5_henry]
    type = InterfaceReactionTest
    variable = N2O5_aq
    neighbor_var = N2O5
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 4.85e1
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [NO_diff]
    type = InterfaceDiffusionTest
    variable = NO_aq
    neighbor_var = 'NO'
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [NO_henry]
    type = InterfaceReactionTest
    variable = NO_aq
    neighbor_var = 'NO'
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 4.4e-2 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [NO2_diff]
    type = InterfaceDiffusionTest
    variable = NO2_aq
    neighbor_var = NO2
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [NO2_henry]
    type = InterfaceReactionTest
    variable = NO2_aq
    neighbor_var = NO2
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 2.8e-1 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []

  [NO3_diff]
    type = InterfaceDiffusionTest
    variable = NO3_aq
    neighbor_var = NO3
    h = 6.48e3
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
  [NO3_henry]
    type = InterfaceReactionTest
    variable = NO3_aq
    neighbor_var = NO3 
    #kf = 6.48e3
    #kb = 1
    kf = 1
    kb = 4.15e1 
    position_units = ${dom1Scale}
    neighbor_position_units = ${dom0Scale}
    boundary = 'water_left'
  []
[]

[BCs]
  [H2_aq_open]
    type = ADDriftDiffusionOpenBC
    variable = H2_aq
    potential = potential
    position_units = ${dom1Scale}
    boundary = 'right'
  []
  # Evaporation boundary condition
  [H2O_right]
    type = DirichletBC
    variable = H2O
    value = 0.38
    boundary = 'gas_right'
  []
  [H2O_left]
    type = ADHagelaarIonDiffusionBC
    variable = H2O
    r = 0
    position_units = ${dom0Scale}
    boundary = 'gas_right'
  []
  [./potential_left]
    type = ADNeumannCircuitVoltageMoles_KV
    variable = potential
    boundary = left
    function = potential_bc_func
    ip = 'N2p N4p Np O2p O2m Om H2Op OHp OHm Hp'
    data_provider = data_provider
    em = em
    mean_en = mean_en
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./potential_dirichlet_right]
    type = DirichletBC
    variable = potential
    boundary = right
    value = 0
  [../]
  [./em_physical_right]
    type = ADHagelaarElectronBC
    variable = em
    boundary = 'gas_right'
    potential = potential
    #ip = Arp
    mean_en = mean_en
    #r = 0.99
    r = 0.0
    position_units = ${dom0Scale}
  [../]

  ############################
  # Gas Phase
  ############################
  # Ions
  [./N2p_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2p
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./N2p_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = N2p
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N4p_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N4p
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./N4p_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = N4p
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]
  
  [./Np_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = Np
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./Np_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = Np
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./O2p_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = O2p
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./O2p_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = O2p
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./O2m_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = O2m
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./O2m_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = O2m
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./Om_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = Om
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./Om_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = Om
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./H2Op_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = H2Op
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./H2Op_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = H2Op
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./OHp_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = OHp
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./OHp_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = OHp
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./Hp_physical_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = Hp 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./Hp_physical_advection]
    type = ADHagelaarIonAdvectionBC
    variable = Hp
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./OHm_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = OHm
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./OHm_physical_right_advection]
    type = ADHagelaarIonAdvectionBC
    variable = OHm 
    boundary = 'left gas_right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  [../]

  # Neutrals
  [./H2O_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = H2O
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  #[./N2v_physical_right_diffusion]
  #  type = ADHagelaarIonDiffusionBC
  #  variable = N2v 
  #  boundary = 'left gas_right'
  #  r = 0
  #  position_units = ${dom0Scale}
  #[../]

  [./N2s_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2s
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N2ss_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2ss 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N2sss_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2ss 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./Ns_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = Ns 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./O2s_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = O2s 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./O_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = O 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./Os_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = Os 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./OH_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = OH 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  #[./OHs_physical_right_diffusion]
  #  type = ADHagelaarIonDiffusionBC
  #  variable = OHs 
  #  boundary = 'left gas_right'
  #  r = 0
  #  position_units = ${dom0Scale}
  #[../]

  [./H2_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = H2 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./H_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = H 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./Hs_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = Hs 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./O3_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = O3 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./HO2_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = HO2 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./H2O2_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = H2O2 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./NO_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = NO 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./NO2_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = NO2 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N2O_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2O 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./NO3_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = NO3 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N2O3_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2O3 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N2O4_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2O4 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  [./N2O5_physical_right_diffusion]
    type = ADHagelaarIonDiffusionBC
    variable = N2O5 
    boundary = 'left gas_right'
    r = 0
    position_units = ${dom0Scale}
  [../]

  # Electron Energy
  [./mean_en_physical_right]
    type = ADHagelaarEnergyBC
    variable = mean_en
    boundary = 'gas_right'
    potential = potential
    em = em
    #r = 0.99
    r = 0.0
    position_units = ${dom0Scale}
  [../]
  [./em_physical_left]
    type = ADHagelaarElectronBC
    variable = em
    boundary = 'left'
    potential = potential
    mean_en = mean_en
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./sec_electrons_left]
    type = ADSecondaryElectronBC
    variable = em
    boundary = 'left'
    potential = potential
    ip = 'N2p N4p Np O2p O2m Om H2Op OHp OHm'
    mean_en = mean_en
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./sec_electrons_energy_left]
    type = ADSecondaryElectronEnergyBC
    variable = mean_en
    boundary = 'left'
    potential = potential
    ip = 'N2p N4p Np O2p O2m Om H2Op OHp OHm'
    em = em
    r = 0
    position_units = ${dom0Scale}
  [../]
  [./mean_en_physical_left]
    type = ADHagelaarEnergyBC
    variable = mean_en
    boundary = 'left'
    potential = potential
    em = em
    r = 0
    position_units = ${dom0Scale}
  [../]

  ###################
  # WATER BCs
  ###################
  [./em_aq_right]
    type = ADDCIonBC
    variable = em_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./OHm_aq_physical]
    type = ADDCIonBC
    variable = OHm_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./H3Op_aq_physical]
    type = ADDCIonBC
    variable = H3Op_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./O2m_aq_physical]
    type = ADDCIonBC
    variable = O2m_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./Om_aq_physical]
    type = ADDCIonBC
    variable = Om_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./HO2m_aq_physical]
    type = ADDCIonBC
    variable = HO2m_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./H2Op_aq_physical]
    type = ADDCIonBC
    variable = H2Op_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./O3m_aq_physical]
    type = ADDCIonBC
    variable = O3m_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./NO2m_aq_physical]
    type = ADDCIonBC
    variable = NO2m_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  [./NO3m_aq_physical]
    type = ADDCIonBC
    variable = NO3m_aq
    boundary = 'right'
    #potential = potential_liq
    potential = potential
    position_units = ${dom1Scale}
  [../]
  #[./OONOm_aq_physical]
  #  type = ADDCIonBC
  #  variable = OONOm_aq
  #  boundary = 'right'
  #  #potential = potential_liq
  #  potential = potential
  #  position_units = ${dom1Scale}
  #[../]
[]

[ICs]
  [./potential_ic]
    type = FunctionIC
    variable = potential
    function = potential_ic_func
    #block = 0
  [../]
  [H2O_ic]
    type = FunctionIC
    variable = H2O
    function = water_ic_func
  []
[]

[Functions]
  [water_ic_func]
    type = ParsedFunction
    value = 'log(8.6949e23/6.022e23)'
    #value = '-2.15'
  []
  [./potential_bc_func]
    type = ParsedFunction
    value = -3
  [../]
  [./potential_ic_func]
    type = ParsedFunction
    value = '-0.01 * (1.001e-3 - x)'
  [../]
[]

[Materials]
  [./se_coefficient]
    type = GenericConstantMaterial
    prop_names = 'se_coeff'
    prop_values = '0.01'
    boundary = 'left gas_right'
  [../]
  [./GasBasics]
    #type = GasBase
    type = ADGasElectronMoments
    interp_elastic_coeff = true
    interp_trans_coeffs = true
    ramp_trans_coeffs = false
    # user_p_gas = 1.01325e5
    user_p_gas = 1.01e5
    em = em
    potential = potential
    mean_en = mean_en
    user_se_coeff = 0.05
    property_tables_file = 'data/electron_mobility_diffusion.txt'
    block = 0
  [../]
  [gas_constants]
    type = GenericConstantMaterial
    prop_names = 'e    N_A    k_boltz    eps     se_energy    T_gas    massem    p_gas diffpotential'
    prop_values = '1.6e-19 6.022e23 1.38e-23 8.854e-12 1 400 9.11e-31 1.01e5 8.854e-12'
    block = 0
  []

  #[./Nap_mat]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = Na+
  #  heavy_species_mass = 3.816e-26
  #  heavy_species_charge = 1.0
  #  diffusivity = 2e-9
  #  block = 1
  #[../]
  #[./Clm_mat]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = Cl-
  #  heavy_species_mass = 5.887e-26
  #  heavy_species_charge = -1.0
  #  diffusivity = 2e-9
  #  block = 1
  #[../]
  [./NO2-_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO2-
    heavy_species_mass = 7.6e-26 
    heavy_species_charge = -1
    diffusivity = 5e-9
    block = 1
  [../]
  [./NO2_2m_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO2_2- 
    heavy_species_mass = 7.6e-26 
    heavy_species_charge = -2
    diffusivity = 5e-9
    block = 1
  [../]
  [./NO3-_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO3-
    heavy_species_mass = 1e-25
    heavy_species_charge = -1
    diffusivity = 5e-9
    block = 1
  [../]
  [./NO3_2m_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO3_2-
    heavy_species_mass = 1e-25 
    heavy_species_charge = -2
    diffusivity = 5e-9 
    block = 1
  [../]

  #[./gas_species_0]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = Arp
  #  heavy_species_mass = 6.64e-26
  #  heavy_species_charge = 1.0
  #  block = 0
  #[../]

  [./gas_species_N2]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2 
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 0
    diffusivity = 2.1e-5 
    block = 0
  [../]

  [./gas_species_N2v]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2v
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 0
    diffusivity = 2.1e-5
    block = 0
  [../]

  [./gas_species_N2s]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2s
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 0
    diffusivity = 5.9e-5
    block = 0
  [../]

  [./gas_species_N2ss]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2ss
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 0
    diffusivity = 5.9e-5
    block = 0
  [../]

  [./gas_species_N2sss]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2sss
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 0
    diffusivity = 5.9e-5
    block = 0
  [../]

  [./gas_species_N]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N
    heavy_species_mass = 2.325922e-26
    heavy_species_charge = 0
    diffusivity = 5.7e-5
  [../]

  [./gas_species_Ns]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Ns
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 0
    diffusivity = 5.9e-5
  [../]

  [./gas_species_Np]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Np
    heavy_species_mass = 2.325922e-26
    heavy_species_charge = 1
    diffusivity = 5.7e-5
  [../]

  [./gas_species_N2p]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2p
    heavy_species_mass = 4.651843e-26
    heavy_species_charge = 1
    diffusivity = 5.9e-5
  [../]

  [./gas_species_N4p]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N4p
    heavy_species_mass = 9.303686e-26
    heavy_species_charge = 1
    diffusivity = 4.1e-5
  [../]

  [./gas_species_O2]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O2
    heavy_species_mass = 5.313650e-26
    heavy_species_charge = 0
    diffusivity = 2.1e-5
    block = 0
  [../]

  #[./gas_species_O2v1]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = O2v1
  #  heavy_species_mass = 5.313650e-26
  #  heavy_species_charge = 0
  #  diffusivity = 2.1e-5
  #[../]

  [./gas_species_O2s]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O2s
    heavy_species_mass = 5.313650e-26
    heavy_species_charge = 0
    diffusivity = 2.1e-5
    block = 0
  [../]

  # Keeping this one - might be useful
  #[./gas_species_O24_ev]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = O24_ev
  #  heavy_species_mass = 5.313650e-26
  #  heavy_species_charge = 0
  #  diffusivity = 2.1e-5
  #[../]

  [./gas_species_O]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O
    heavy_species_mass = 2.656825e-26
    heavy_species_charge = 0
    diffusivity = 6e-5
    block = 0
  [../]

  [./gas_species_Os]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Os
    heavy_species_mass = 2.656825e-26
    heavy_species_charge = 0
    diffusivity = 6e-5
    block = 0
  [../]

  [./gas_species_O3]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O3
    heavy_species_mass = 7.970475e-26
    heavy_species_charge = 0
    diffusivity = 2e-5 
    block = 0
  [../]

  [./gas_species_Op]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Op
    heavy_species_mass = 2.656825e-26
    heavy_species_charge = 1
    diffusivity = 5.8e-5
    block = 0
  [../]

  [./gas_species_Hp]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Hp
    heavy_species_mass = 1.673597e-27
    heavy_species_charge = 1
    diffusivity = 8.8e-5
    block = 0
  [../]

  [./gas_species_O2p]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O2p
    heavy_species_mass = 5.313650e-26
    heavy_species_charge = 1
    diffusivity = 5.6e-5
    block = 0
  [../]

  [./gas_species_Om]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Om
    heavy_species_mass = 2.656825e-26
    heavy_species_charge = -1
    diffusivity = 7.0e-5
    block = 0
  [../]

  [./gas_species_O2m]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O2m
    heavy_species_mass = 5.313650e-26
    heavy_species_charge = -1
    diffusivity = 5.6e-5
    block = 0
  [../]

  [./gas_species_NO]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO 
    heavy_species_mass = 4.982747e-26
    heavy_species_charge = 0
    diffusivity = 2e-5
    block = 0
  [../]

  #[./gas_species_O2pN2]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = O2pN2
  #  heavy_species_mass = 9.965493e-26
  #  heavy_species_charge = 1
  #  diffusivity = 0.5e-5
  #[../]

  # Additional nitrogen-oxygen species

  [./gas_species_N2O]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O
    heavy_species_mass = 7.308668e-26
    heavy_species_charge = 0
    diffusivity = 1.6e-5
    block = 0
  [../]

  [./gas_species_NO2]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO2
    heavy_species_mass = 7.639572e-26
    heavy_species_charge = 0
    diffusivity = 1.7e-5
    block = 0
  [../]

  [./gas_species_NO3]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO3
    heavy_species_mass = 1.029640e-25
    heavy_species_charge = 0
    diffusivity = 0.9e-5
    block = 0
  [../]

  [./gas_species_N2O3] # dinitrogen trioxide 
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O3
    heavy_species_mass = 1.262205e-25
    heavy_species_charge = 0
    diffusivity = 1e-5
    block = 0
  [../]

  [./gas_species_N2O4] # dinitrogen tetroxide
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O4
    heavy_species_mass = 1.527914e-25
    heavy_species_charge = 0
    diffusivity = 1e-5
    block = 0
  [../]

  [./gas_species_N2O5] # dinitrogen pentoxide
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O5
    heavy_species_mass = 1.793597e-25
    heavy_species_charge = 0
    diffusivity = 1e-5
    block = 0
  [../]


  # Hydrogen species
  #[./gas_species_Hp]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = H+
  #  heavy_species_mass = 1.673597e-27
  #  heavy_species_charge = 1
  #  diffusivity = 8.8e-5
  #[../]

  #[./gas_species_H2p]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = H2+
  #  heavy_species_mass = 3.347526e-27
  #  heavy_species_charge = 1
  #  diffusivity = 7e-5
  #[../]
  #
  #[./gas_species_H3p]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = H3+
  #  heavy_species_mass = 5.021289e-27
  #  heavy_species_charge = 1
  #  diffusivity = 9e-5
  #[../]

  [./gas_species_OHp]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OHp
    heavy_species_mass = 2.824311e-26
    heavy_species_charge = 1
    diffusivity = 4e-5
    block = 0
  [../]

  [./gas_species_H2Op]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2Op
    heavy_species_mass = 2.988e-26 
    heavy_species_charge = 1
    diffusivity = 5.9e-5
    block = 0
  [../]

  [./gas_species_H3Op]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H3Op
    heavy_species_mass = 3.158951e-26 
    heavy_species_charge = 1
    diffusivity = 6e-5
    block = 0
  [../]

  #[./gas_species_Hm]
  #  type = ADHeavySpeciesMaterial
  #  heavy_species_name = H-
  #  heavy_species_mass = 1.673597e-27
  #  heavy_species_charge = -1
  #  diffusivity = 8.8e-5
  #[../]

  [./gas_species_OHm]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OHm
    heavy_species_mass = 2.824311e-26
    heavy_species_charge = -1
    diffusivity = 7e-5
    block = 0
  [../]

  [./gas_species_H]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H
    heavy_species_mass = 1.673597e-27
    heavy_species_charge = 0
    diffusivity = 8.8e-5
    block = 0
  [../]

  [./gas_species_Hs]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Hs
    heavy_species_mass = 1.673597e-27
    heavy_species_charge = 0
    diffusivity = 8.8e-5
    block = 0
  [../]

  [./gas_species_H2]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2
    heavy_species_mass = 3.347526e-27
    heavy_species_charge = 0
    diffusivity = 7.8e-5
    block = 0
  [../]

  [./gas_species_OH]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OH
    heavy_species_mass = 2.824311e-26
    heavy_species_charge = 0
    diffusivity = 4e-5
    block = 0
  [../]

  [./gas_species_OHs]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OHs
    heavy_species_mass = 2.824311e-26
    heavy_species_charge = 0
    diffusivity = 4e-5
    block = 0
  [../]

  [./gas_species_HO2]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HO2
    heavy_species_mass = 5.481069e-26
    heavy_species_charge = 0
    diffusivity = 2e-5
    block = 0
  [../]

  [./gas_species_H2O2]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2O2
    heavy_species_mass = 5.64829e-26
    heavy_species_charge = 0
    diffusivity = 2e-5
    block = 0
  [../]

  [./gas_species_HNO] # Nitroxyl
    type = ADHeavySpeciesMaterial
    heavy_species_name = HNO
    heavy_species_mass = 5.150116e-26
    heavy_species_charge = 0
    diffusivity = 2.1e-5
    block = 0
  [../]

  [./gas_species_HNO2] # Nitrous acid
    type = ADHeavySpeciesMaterial
    heavy_species_name = HNO2
    heavy_species_mass = 7.8087e-26
    heavy_species_charge = 0
    diffusivity = 2.1e-5
    block = 0
  [../]

  [./gas_species_HNO3] # Nitric acid
    type = ADHeavySpeciesMaterial
    heavy_species_name = HNO3
    heavy_species_mass = 1.04633e-25
    heavy_species_charge = 0
    diffusivity = 2.1e-5
    block = 0
  [../]

  [./gas_species_H2O]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2O
    heavy_species_mass = 2.988e-26
    heavy_species_charge = 0 
    diffusivity = 2.3e-5 
    block = 0
  [../]

  ###################################
  # WATER SPECIES
  ###################################
  [./OHm_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OHm_aq
    heavy_species_mass = 2.82420e-26
    heavy_species_charge = -1
    diffusivity = 5.27e-9
    block = 1
  [../]

  [./O_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O_aq
    heavy_species_mass = 2.6566962e-26
    heavy_species_charge = 0
    diffusivity = 5.00e-9
    block = 1
  [../]

  [./O3_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O3_aq
    heavy_species_mass = 7.97047e-26
    heavy_species_charge = 0
    diffusivity = 5e-9
    block = 1
  [../]

  [./OH_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OH_aq
    heavy_species_mass = 2.82431e-26
    heavy_species_charge = 0
    diffusivity = 4.5e-9
    block = 1
  [../]

  [./HO2_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HO2_aq
    heavy_species_mass = 5.481026e-26
    heavy_species_charge = 0
    diffusivity = 5.00e-9
    block = 1
  [../]

  [./HO3_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HO3_aq
    heavy_species_mass = 5.481026e-26
    heavy_species_charge = 0
    diffusivity = 5.00e-9
    block = 1
  [../]

  [./H2O2_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2O2_aq
    heavy_species_mass = 5.64840e-26
    heavy_species_charge = 0
    diffusivity = 5.00e-9
    block = 1
  [../]

  [./H2Op_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2Op_aq
    heavy_species_mass = 2.992e-26 
    heavy_species_charge = 1
  [../]

  [./H2_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H2_aq
    heavy_species_mass = 3.34752e-26
    heavy_species_charge = 0
    diffusivity = 4.50e-9
    block = 1
  [../]

  [./H_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H_aq
    heavy_species_mass = 1.67376e-26
    heavy_species_charge = 0
    diffusivity = 5.0e-9
    block = 1
  [../]

  [./H+_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Hp_aq
    heavy_species_mass = 1.67376e-26
    heavy_species_charge = 1
    diffusivity = 9.31e-9
    # (Is this really the same as H3O+? I don't understand)
    block = 1
  [../]

  [./H3O+_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = H3Op_aq
    heavy_species_mass = 3e-26
    # ^ just estimated...whatever
    heavy_species_charge = 1
    diffusivity = 9.31e-9
    # (Is this really the same as H3O+? I don't understand)
    block = 1
  [../]

  [./HO2-_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HO2m_aq
    heavy_species_mass = 5.481026e-26
    heavy_species_charge = -1
    diffusivity = 5e-9
    block = 1
  [../]

  [./Om_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = Om_aq
    heavy_species_mass = 2.6566962e-26
    heavy_species_charge = -1
    diffusivity = 5e-9
    block = 1
  [../]

  [./O2m_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O2m_aq
    heavy_species_mass = 5.31365e-26
    heavy_species_charge = -1
    diffusivity = 5e-9 
    block = 1
  [../]

  [./O3m_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O3m_aq
    heavy_species_mass = 7.97047e-26
    heavy_species_charge = -1
    diffusivity = 5e-9
    block = 1
  [../]

  [./O2_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = O2_aq
    heavy_species_mass = 5.31365e-26
    heavy_species_charge = 0
    diffusivity = 2e-9
    block = 1
  [../]

  # Aqueous nitrogen species
  # All following diffusion coefficients taken from 
  # Verlackt, C. et al. "Transport and accumulation of plasma generated species
  # in aqueous solution." Phys. Chem. Chem. Phys. 2018, 20, 6845
  # (Values listed in Supplementary Information)
  [./NO2m_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO2m_aq
    heavy_species_mass = 7.63957e-26 
    heavy_species_charge = -1 
    diffusivity = 1.7e-9 
    block = 1
  [../]

  [./NO3m_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO3m_aq
    heavy_species_mass = 1.02964e-25 
    heavy_species_charge = -1
    diffusivity = 1.7e-9 
    block = 1
  [../]

  [./OONOm_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = OONOm_aq
    heavy_species_mass = 1.02964e-25 
    heavy_species_charge = -1
    diffusivity = 1.7e-9 
    block = 1
  [../]
  
  [./NO_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO_aq
    heavy_species_mass = 4.98339e-26 
    heavy_species_charge = 0
    diffusivity = 2.2e-9 
    block = 1
  [../]

  [./NO2_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO2_aq
    heavy_species_mass = 7.63957e-26 
    heavy_species_charge = 0
    diffusivity = 1.85e-9 
    block = 1
  [../]

  [./NO3_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = NO3_aq
    heavy_species_mass = 1.02964e-25 
    heavy_species_charge = 0
    diffusivity = 2.5e-9 
    block = 1
  [../]

  [./HNO2_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HNO2_aq
    heavy_species_mass = 7.8e-26 
    heavy_species_charge = 0
    diffusivity = 2.5e-9 
    block = 1
  [../]

  [./HNO3_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HNO3_aq
    heavy_species_mass = 1e-25 
    heavy_species_charge = 0
    diffusivity = 2.5e-9 
    block = 1
  [../]

  [./HOONO_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = HOONO_aq
    heavy_species_mass = 1e-25 
    heavy_species_charge = 0
    diffusivity = 2.5e-9 
    block = 1
  [../]

  [./N2O3_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O3_aq
    heavy_species_mass = 1.3e-25 
    heavy_species_charge = 0
    diffusivity = 1e-9 
    block = 1
  [../]

  [./N2O4_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O4_aq
    heavy_species_mass = 1.5e-25 
    heavy_species_charge = 0
    diffusivity = 1e-9 
    block = 1
  [../]

  [./N2O5_aq_mat]
    type = ADHeavySpeciesMaterial
    heavy_species_name = N2O5_aq
    heavy_species_mass = 1.8e-25
    heavy_species_charge = 0
    diffusivity = 1e-9 
    block = 1
  [../]

  [./electron_data]
    type = ADGenericConstantMaterial
    prop_names = 'diffem_aq muem_aq Tem_aq'
    prop_values = '4.5e-9 0.000173913 300'
    block = 1
  [../]
  [./electron_sign]
    # I increased the electron mass by a factor of 10 here
    # Not sure what it's really supposed to be
    type = GenericConstantMaterial
    prop_names = 'sgnem_aq massem_aq'
    prop_values = '-1 9.11e-30'
    block = 1
  [../]

  [./N_A_mat]
    type = GenericConstantMaterial
    prop_names = 'N_A e diffpotential diffpotential_liq T_gas p_gas'
    prop_values = '6.022e23 1.602e-19 7.0832e-10 7.0832e-10 300 1.013e5'
    block = 1
  [../]
[]

[Reactions]
  # Both reaction networks taken from
  # Wei Tian. "MODELLING INTERACTIONS OF ATMOSPHERIC PRESSURE PLAMSAS WITH
  # LIQUIDS." (2015) PhD Dissertation
  # (See Appendix I)
  #
  # (Ammonia reactions included myself)
  # 
  # Note that N2s   = N2(A) and N2(B)
  #           N2ss  = N2(a')
  #           N2sss = N2(C)
  #           N2v   = N2(v1), N2(v2), ... N2(v8)
  #           (but really it's just N2(v1) here for simplicity)
  #
  #           O2s = O2(A3), O2(B3)
  #                 (Corresponds to O2(0.98) and O2(1.63), respectively)


  # N2 cross sections taken from Itikawa database (lxcat)
  #
  # N cross sections taken from IST_Lisbon database
  # P. Coche et al. "Microwave air plasmas in capillaries at low pressure I. 
  # Self-consistent modeling." 2016 J. Phys. D: Appl. Phys. 49 235207
  # Note that half of the cross sections have been removed for the N 
  # excitation reactions. 
  # (There were too many data points for Bolsig+.)
  #
  # O2 cross sections taken from Ionin database: 
  # "Physics and engineering of singlet delta oxygen production in low-
  # temperature plasma." J. Phys. D: Appl. Phys. 40 (2007)
  # 
  # H2O cross section taken from
  # Y Itikawa and N Mason, Cross Sections for Electron Collisions with 
  # Water Molecules, J. Phys. Chem. Ref. Data 34, 1 (2005) 
  # 
  # H cross sections taken from Shimamura (???)
  # Could not find Hs** - excluded from this simulation
  # Hs = H(2s)
  # Hs* = H(2p)
  [gas_reactions]
    #species = 'em N2v N2p N4p N2s N2ss N2sss N Ns Np O2p O2m O2s Om O Os H2O H2Op H2 H Hs O3 HO2 H2O2 NO NO2 N2O NO3 N2O3 N2O4 N2O5 OHm OHp OH OHs Hp'
    species = 'em N2p N4p N2s N2ss N2sss N Ns Np O2p O2m O2s Om O Os H2O H2Op H2 H Hs O3 HO2 H2O2 NO NO2 N2O NO3 N2O3 N2O4 N2O5 OHm OHp OH Hp'
    aux_species = 'N2 O2'
    reaction_coefficient_format = 'townsend'
    #reaction_coefficient_format = 'rate'
    electron_energy = 'mean_en'
    electron_density = 'em'
    equation_constants = 'Tgas Tn'
    equation_values = '300 1'
    equation_variables = 'Te'
    file_location = 'data'
    potential = 'potential'
    position_units = ${dom0Scale}
    use_log = true
    use_ad = true
    track_rates = false
    convert_to_meters = 1e-2
    convert_to_moles = true
    block = 0

    reactions = 'em + N2 -> em + N2               : EEDF [elastic] (C1_N2_Elastic)
                 em + N2 -> N2s + em              : EEDF [-6.17] (C3_N2_Excitation_6.17_eV)
                 em + N2 -> N2s + em              : EEDF [-7.35] (C4_N2_Excitation_7.35_eV)
                 em + N2s -> N2 + em              : EEDF [6.17] (C11_N2A3_De-excitation_6.17_eV)
                 em + N2s -> N2 + em              : EEDF [7.35] (C12_N2B3_De-excitation_7.35_eV)
                 em + N2 -> N2ss + em             : EEDF [-8.40] (C5_N2_Excitation_8.40_eV)
                 em + N2ss -> N2 + em             : EEDF [8.40] (C13_N2ap1_De-excitation_8.40_eV)
                 em + N2 -> N2sss + em            : EEDF [-11.03] (C6_N2_Excitation_11.03_eV)
                 em + N2sss -> N2 + em            : EEDF [11.03] (C14_N2C3_De-excitation_11.03_eV)
                 # Could not find stepwize excitation cross sections on lxcat
                 # May look them up later
                 #em + N2s -> N2ss + em            : EEDF [] (C_N2_Excitation__eV)
                 #em + N2ss -> N2s + em            : EEDF [] (C_N2_Excitation__eV)
                 #em + N2s -> N2sss + em           : EEDF [] (C_N2_Excitation__eV)
                 #em + N2sss -> N2s + em           : EEDF [] (C_N2_Excitation__eV)
                 #em + N2ss -> N2sss + em          : EEDF [] (C_N2_Excitation__eV)
                 #em + N2sss -> N2ss + em          : EEDF [] (C_N2_Excitation__eV)
                 em + N2 -> N2p + em + em         : EEDF [-15.58] (C8_N2_Ionization_15.58_eV)
                 # next one added myself, probably not useful since energy is so high
                 em + N2 -> em + em + N + Np      : EEDF [-30] (C9_N2_Ionization_30.00_eV)
                 #em + N2s -> N2p + em + em        : EEDF [] ()
                 #em + N2ss -> N2p + em + em       : EEDF [] ()
                 #em + N2sss -> N2p + em + em      : EEDF [] ()
                 em + N2 -> N + N + em            : EEDF [-9.75] (C7_N2_Excitation_9.75_eV)
                 #em + N2 -> N2v + em              : EEDF [-0.29] (C2_N2_Excitation_0.29_eV)
                 #em + N2v -> N2 + em              : EEDF [0.29] (C10_N2v1_De-excitation_0.29_eV)
                 # Does this next one even happen??
                 #em + N2v -> em + em + N2p        : EEDF [] (C_N2_Excitation__eV)
                 em + N -> em + N                 : EEDF [elastic] (C15_N_Elastic)
                 em + N -> em + Ns                : EEDF [-2.39] (C16_N_Excitation_2.39_eV)
                 em + N -> em + Ns                : EEDF [-3.57] (C17_N_Excitation_3.57_eV)
                 em + Ns -> em + N                : EEDF [3.57] (C19_N2P_De-excitation_3.57_eV)
                 em + Ns -> em + N                : EEDF [2.39] (C20_N2D_De-excitation_2.39_eV)
                 em + N -> em + em + Np           : EEDF [-14.54] (C18_N_Ionization_14.54_eV)
                 #em + Ns -> em + em + Np          : EEDF [] ()
                 #em + N2s -> N + N + em           : EEDF [] ()
                 #em + N2ss -> N + N + em          : EEDF [] ()
                 # Only one of the 2 following reactions should be used
                 # (Depends on if Ns is tracked)
                 #em + N2p -> N + N                : {2e-7*Te^(-0.5)}
                 em + N2p -> Ns + N                : {2e-7*Te^(-0.5)}
                 em + N4p -> N2 + N2              : {2e-7*Te^(-0.5)}
                 #Ns + N2 -> N + N2                : 2.4e-14
                 #########################
                 # H2O, OH, and H reactions
                 #########################
                 em + H2O -> em + H2O             : EEDF [elastic] (C38_H2O_Elastic)
                 em + H2O -> em + em + H2Op       : EEDF [-13.50] (C45_H2O_Ionization_13.50_eV)
                 em + H2O -> H2Ov + em            : EEDF [-0.198] (C43_H2O_Excitation_0.20_eV)
                 em + H2O -> OHm + H              : EEDF (C36_H2O_Attachment)
                 em + H2O -> H2 + Om              : EEDF (C37_H2O_Attachment)
                 em + H2O -> em + H + OH          : EEDF (C42_H2O_Excitation_0.0000_eV)
                 # It is unclear what Hs* and Hs** refer to in the thesis
                 #em + H2O -> em + OH + Hs         : EEDF [] (C_H2O_Excitation__eV)
                 #em + H2O -> em + OH + Hs*        : EEDF [] (C_H2O_Excitation__eV)
                 #em + H2O -> em + OH + Hs**       : EEDF [] (C_H2O_Excitation__eV)
                 #em + H2O -> em + OHs + H         : EEDF [-9.00] (C44_H2O_Excitation_9.00_eV) 
                 # Removed OHs
                 em + H2O -> em + OH + H         : EEDF [-9.00] (C44_H2O_Excitation_9.00_eV) 
                 em + H -> em + Hs                : EEDF [-10.2] (C47_H_Excitation_10.20_eV)
                 em + H -> em + Hs                : EEDF [-10.2] (C48_H_Excitation_10.20_eV)
                 em + Hs -> em + H                : EEDF [10.2] (C50_H2p10.2eV_De-excitation_10.20_eV)
                 em + Hs -> em + H                : EEDF [10.2] (C51_H2s10.2eV_De-excitation_10.20_eV)
                 em + O2 -> em + O2               : EEDF [elastic] (C22_O2_Elastic)
                 em + O2 -> O2s + em              : EEDF [-0.98] (C24_O2_Excitation_0.98_eV)
                 em + O2 -> O2s + em              : EEDF [-1.63] (C25_O2_Excitation_1.63_eV)
                 em + O2s -> em + O2              : EEDF [0.98] (C28_O20.98_De-excitation_0.98_eV)
                 em + O2s -> em + O2              : EEDF [1.63] (C32_O21.63_De-excitation_1.63_eV)
                 em + O2 -> em + em + O2p         : EEDF [-12.1] (C26_O2_Ionization_12.10_eV)
                 em + O2s -> em + em + O2p        : EEDF [-11.10] (C30_O20.98_Ionization_11.10_eV)
                 em + O2s -> em + em + O2p        : EEDF [-10.45] (C34_O21.63_Ionization_10.45_eV)
                 em + O2s -> em + em + Op + O     : EEDF [-18.52] (C31_O20.98_Ionization_18.52_eV)
                 em + O2s -> em + em + Op + O     : EEDF [-17.87] (C35_O21.63_Ionization_17.87_eV)
                 em + O2 -> Om + O                : EEDF (C21_O2_Attachment)
                 em + O2s -> Om + O               : EEDF (C29_O20.98_Attachment)
                 em + O2s -> Om + O               : EEDF (C33_O21.63_Attachment)
                 em + O2p -> O + O                : {1.2e-8*Te^(-0.7)} 
                 #em + H -> em + Hs*               : EEDF [] (C_H_Excitation__eV)
                 #em + Hs* -> em + H               : EEDF [] (C_H_Excitation__eV)
                 #em + H -> em + Hs**              : EEDF [] (C_H_Excitation__eV)
                 #em + Hs** -> em + H              : EEDF [] (C_H_Excitation__eV)
                 #em + Hs -> em + Hs*              : EEDF [] (C_H_Excitation__eV)
                 #em + Hs* -> em + Hs              : EEDF [] (C_H_Excitation__eV)
                 #em + Hs -> em + Hs**             : EEDF [] (C_H_Excitation__eV)
                 #em + Hs** -> em + Hs             : EEDF [] (C_H_Excitation__eV)
                 #em + Hs* -> em + Hs**            : EEDF [] (C_H_Excitation__eV)
                 #em + Hs** -> em + Hs*            : EEDF [] (C_H_Excitation__eV)
                 # Cannot find cross section of OH
                 #em + OH -> em + OHs              : EEDF [] (C_OH_Excitation__eV)
                 #em + OHs -> em + O + H           : {2.7e-10*Te^(0.5)} 
                 Hs + H2O -> H + H2O              : 9.1e-9
                 #Hs* + H2O -> H + H2O             : 9.1e-9 
                 #Hs** + H2O -> H + H2O            : 9.1e-9
                 #Hs* + H2O -> Hs + H2O            : 9.1e-9
                 #Hs** + H2O -> Hs + H2O           : 9.1e-9
                 #Hs** + H2O -> Hs* + H2O          : 9.1e-9
                 #OHs + H2O -> OH + H2O            : 9.1e-9
                 OHm + H -> H2O + em              : 1.8e-9
                 OH + H -> H2O                    : {6.87e-31*Tn^(-2)}
                 #OHs + H -> H2O                   : {6.87e-31*Tn^(-2)}
                 #OHs + OHs + O2 -> H2O2 + O2      : {6.9e-31*Tn^(-0.8)} 
                 #OHs + OHs + H2O -> H2O2 + H2O    : {6.9e-31*Tn^(-0.8)} 
                 H2 + HO2 -> H2O2 + H             : {5e-11*exp(-Tgas/11310)}
                 HO2 + HO2 -> H2O2 + O2           : {8.05e-11*Tn^(-1)}
                 HO2 + HO2 + O2 -> H2O2 + O2 + O2 : {1.9e-33*exp(980/Tgas)}
                 HO2 + HO2 + H2O -> H2O2 + O2 + H2O : {1.9e-33*exp(980/Tgas)}
                 HO2 + H2O -> H2O2 + OH           : {4.65e-11*exp(-11647/Tgas)} 
                 H + H2O2 -> HO2 + H2             : {8e-11*exp(-4000/Tgas)}
                 H + H2O2 -> OH + H2O             : {4e-11*exp(-2000/Tgas)}
                 Hs + H2O2 -> OH + H2O            : {4e-11*exp(-2000/Tgas)}
                 O2 + H2O2 -> HO2 + HO2           : {9e-11*exp(-19965/Tgas)}
                 O + H2O2 -> HO2 + OH             : {1.4e-12*exp(-2000/Tgas)}
                 Os + H2O2 -> O2 + H2O            : 5.2e-10
                 OH + H2O2 -> HO2 + H2O           : {2.9e-12*exp(-160/Tgas)}
                 H2O2 -> OH + OH                  : {1.96e-9*Tn^(-4.86)*exp(-26800/Tgas)}
                 #Hs* + H2O2 -> OH + H2O           : {4e-11*exp(-2000/Tgas)}
                 #Hs** + H2O2 -> OH + H2O          : {4e-11*exp(-2000/Tgas)}
                 OHm + OHp + N2 -> H2O2 + N2      : {2e-25*Tn^(-2.5)}
                 OHm + OHp + O2 -> H2O2 + O2      : {2e-25*Tn^(-2.5)}
                 OHm + OHp + H2O -> H2O2 + H2O    : {2e-25*Tn^(-2.5)}
                 OHm + H2Op + N2 -> OH + H2O + N2 : {2e-25*Tn^(-2.5)}
                 OHm + H2Op + O2 -> OH + H2O + O2 : {2e-25*Tn^(-2.5)}
                 OHm + H2Op + H2O -> OH + H2O + H2O : {2e-25*Tn^(-2.5)}
                 O2m + O2p -> O2 + O2             : 2e-6
                 O2m + H2Op -> O2 + H2O           : 2e-6
                 Om + O2p -> O + O2               : 3e-6
                 Om + OHp + N2 -> HO2 + N2        : {2e-25*Tn^(-2.5)}
                 Om + OHp + O2 -> HO2 + O2        : {2e-25*Tn^(-2.5)}
                 Om + OHp + H2O -> HO2 + H2O      : {2e-25*Tn^(-2.5)}
                 Om + H2Op + N2 -> O + H2O + N2   : {2e-25*Tn^(-2.5)}
                 Om + H2Op + O2 -> O + H2O + O2   : {2e-25*Tn^(-2.5)}
                 Om + H2Op + H2O -> O + H2O + H2O : {2e-25*Tn^(-2.5)}
                 Om + O2 -> O2m + O               : 1.5e-20
                 Om + O3 -> O2 + O2m              : 1e-11
                 O2m + O -> O3 + em               : 1.5e-10
                 O2m + O -> Om + O2               : 1.5e-10
                 O2m + O2s -> O2 + O2 + em        : 2e-10
                 O2s + O2 -> O2 + O2              : 2.2e-18
                 O2s + H2O -> O2 + H2O            : 2.2e-18
                 O2s + O2 -> O + O3               : 2.9e-21
                 O2s + O3 -> O2 + O2 + O          : 9.9e-11
                 ##########################################
                 # Radiative Transitions H2O, OH, etc.
                 ##########################################
                 #OHs -> OH                              : 1.3e6
                 Hs -> H                                : 4.7e8
                 ##########################################
                 # Additional reactions (from Van Gaens et al)
                 ##########################################
                 # Next one is commented because Op is not tracked
                 #H + Op -> Hp + O               : {5.66e-10*(Tgas/300)^0.36*exp(8.6/Tgas)}
                 H + Om -> OH + em              : 5e-10
                 Hp + OH -> H + OHp             : 2.1e-9
                 Hp + H2O -> H2Op + H           : 6.9e-9
                 H2Op + O2 -> H2 + O2p          : 8e-10
                 OH + O -> H + O2               : {2.08e-11*(Tgas/300)^(-0.186)*exp(-154/Tgas)}
                 OH + O2m -> OHm + O2           : 1e-10
                 OH + O3 -> HO2 + O2            : 1.69e-12
                 #################################
                 # H2O+ Rxns
                 # (Van Gaens, page 40)
                 #################################
                 H2Op + Om + H2O -> H2O2 + H2O  : {2e-25*(Tgas/300)^(-2.5)}
                 em + H2Op -> O + H2            : {6.27e-9*(Tgas/300)^(-0.5)}
                 em + H2Op -> O + H + H         : {4.9e-8*(Tgas/300)^(-0.5)}
                 ##################################
                 # Electron-impact of Hydrogen
                 ##################################
                 em + H -> em + em + Hp         : EEDF [-13.60] (C49_H_Ionization_13.60_eV)
                 ###################################
                 # OH, OHp reactions
                 # (Van Gaens)
                 ###################################
                 em + OHp -> O + H              : {6.03e-9*(Tgas/300)^(-0.5)}
                 em + OH -> em + O + H          : {2.08e-7*(Tgas/300)^(-0.76)*exp(-6.9/Tgas)}
                 ##############################
                 # H2O Reactions
                 ##############################
                 # Why do these reaction networks have different rate coefficients
                 # for the SAME REACTION? What the hell?
                 em + H2Op -> H + OH              : {1.2e-8*Te^(-0.7)} 
                 #em + H2Op -> H + OH              : {5.1e-8*Te^(-0.5)} 
                 N2p + N2 + N2 -> N4p + N2        : {6.8e-29*Tn^(-1.64)}
                 N2p + N2 + O2 -> N4p + O2        : {6.8e-29*Tn^(-1.64)}
                 N2p + N2 + H2O -> N4p + H2O      : {6.8e-29*Tn^(-1.64)}
                 N4p + N2 -> N2p + N2 + N2        : {9.35e-13*Tn^(1.5)}
                 N4p + O2 -> N2p + N2 + O2        : {9.35e-13*Tn^(1.5)}
                 N4p + H2O -> N2p + N2 + H2O      : {9.35e-13*Tn^(1.5)}
                 O2m + N4p -> O2 + N2 + N2        : 2e-6
                 O2m + N2p -> O2 + N2             : 2e-6
                 O2m + O2p -> O2 + O2             : 2e-6
                 O2m + H2Op -> O2 + H2O           : 2e-6
                 Om + N4p -> O + N2 + N2          : 3e-6
                 Om + N2p -> O + N2               : 3e-6
                 Om + O2p -> O + O2               : 3e-6
                 Om + H2Op -> O + H2O             : 3e-6
                 Om + O2p + N2 -> O + O2 + N2     : {2e-25*Tn^(-2.5)}
                 Om + O2p + O2 -> O + O2 + O2     : {2e-25*Tn^(-2.5)}
                 Om + O2p + H2O -> O + O2 + H2O   : {2e-25*Tn^(-2.5)}
                 Om + O2 -> O2m + O               : 1.5e-20
                 # AGAIN. Same reaction, different rate. Why?!
                 Om + O -> O2 + em                : 1.9e-10
                 #Om + O -> O2 + em                : 5e-10
                 Om + O3 -> O2 + O2 + em          : 3.1e-10
                 Om + O3 -> O2 + O2m              : 1e-11
                 O2m + O -> O3 + em               : 1.5e-10
                 O2m + O -> Om + O2               : 1.5e-10
                 O2m + O2s -> O2 + O2 + em        : 2e-10
                 N2p + O2 -> O2p + N2             : 5.1e-11
                 #O2p + O2 -> O2 + O2p             : 1e-9
                 H2Op + H2O -> H2O + H2Op         : 5.1e-11
                 O2s + N2 -> O2 + N2              : 2.2e-18
                 O2s + O2 -> O2 + O2              : 2.2e-18
                 O2s + H2O -> O2 + H2O            : 2.2e-18
                 O2s + O2 -> O + O3               : 2.9e-21
                 O2s + O3 -> O2 + O2 + O          : 9.9e-11
                 N2s + N2 -> N2 + N2              : 1.9e-13
                 N2ss + N2 -> N2 + N2             : 1.9e-13
                 N2sss + N2 -> N2 + N2            : 1.9e-13
                 N2s + N2s -> N2 + N2ss           : 1e-10
                 #N2v + N2 -> N2 + N2              : 1e-11
                 #N2v + N -> N2 + N                : 1e-11
                 N2sss + N2s -> N4p + em          : 5e-11
                 N2sss + N2ss -> N4p + em         : 5e-11
                 N2sss + N2sss -> N4p + em        : 2e-10
                 #Np + N -> N + Np                 : 5e-12
                 N2p + N -> N2 + Np               : 5e-12
                 N2p + Ns -> N2 + Np              : 1e-10
                 N4p + N2 -> N2 + N2 + N2p        : {9.35e-13*Tn^(1.5)}
                 N2s + O2 -> N2 + O2              : 2.8e-11 
                 N2ss + O2 -> N2 + O2             : 2.8e-11 
                 N2s + O2 -> N2 + O + O           : 2.8e-11 
                 N2ss + O2 -> N2 + O + O          : 1.5e-12 
                 O + O2 + N2 -> O3 + N2           : {6.9e-34*Tn^(-1.2)}
                 O + O2 + O2 -> O3 + O2           : {6.9e-34*Tn^(-1.2)}
                 O + O2 + H2O -> O3 + H2O         : {6.9e-34*Tn^(-1.2)}
                 O + O + N2 -> O2 + N2            : 5.2e-35
                 O + O + O2 -> O2 + O2            : 5.2e-35
                 O + O + H2O -> O2 + H2O          : 5.2e-35
                 N + N + N2 -> N2 + N2            : 3.9e-33
                 N + N + O2 -> N2 + O2            : 3.9e-33
                 N + N + H2O -> N2 + H2O          : 3.9e-33
                 OH + OH + N2 -> H2O2 + N2        : {6.9e-35*Te^(-0.8)}
                 OH + OH + O2 -> H2O2 + O2        : {6.9e-35*Te^(-0.8)}
                 OH + OH + H2O -> H2O2 + H2O      : {6.9e-35*Te^(-0.8)}
                 HO2 + HO2 -> H2O2 + O2           : {8e-11*Te^(-1)}
                 HO2 + HO2 + N2 -> H2O2 + O2 + N2    : 1.9e-33
                 HO2 + HO2 + O2 -> H2O2 + O2 + O2    : 1.9e-33
                 HO2 + HO2 + H2O -> H2O2 + O2 + H2O  : 1.9e-33
                 N + O + N2 -> NO + N2            : 5.5e-33
                 N + O + O2 -> NO + O2            : 5.5e-33
                 N + O + H2O -> NO + H2O          : 5.5e-33
                 N + O2 -> NO + O                 : 8.5e-17
                 N + O3 -> NO + O2                : 5e-16
                 N + NO2 -> N2O + O               : 1.2e-11
                 NO + O2s -> NO + O2              : 3.5e-17
                 NO + O2s -> NO2 + O              : 4.9e-18
                 NO + O3 -> NO2 + O2              : 1.8e-14
                 NO2 + O3 -> NO3 + O2             : 3.2e-17
                 NO + NO2 -> N2O3                 : 7.9e-12
                 NO2 + NO2 -> N2O4                : 1e-12
                 NO2 + NO3 -> N2O5                : 1.9e-12
                 NO + NO + O2 -> NO2 + NO2        : 2e-38
                 NO + O + N2 -> NO2 + N2          : 1e-31
                 NO + O + O2 -> NO2 + O2          : 1e-31
                 NO + O + H2O -> NO2 + H2O        : 1e-31
                 NO + NO2 + N2 -> N2O3 + N2       : 3.1e-34
                 NO + NO2 + O2 -> N2O3 + O2       : 3.1e-34
                 NO + NO2 + H2O -> N2O3 + H2O     : 3.1e-34
                 NO2 + NO2 + N2 -> N2O4 + N2      : 1.4e-33
                 NO2 + NO2 + O2 -> N2O4 + O2      : 1.4e-33
                 NO2 + NO2 + H2O -> N2O4 + H2O    : 1.4e-33
                 NO2 + NO3 + N2 -> N2O5 + N2      : 3.6e-30
                 NO2 + NO3 + O2 -> N2O5 + O2      : 3.6e-30
                 NO2 + NO3 + H2O -> N2O5 + H2O    : 3.6e-30'
  []

  # Rate coefficients are in m^3 s^-1
  # Taken from Wei Tian's thesis
  # Note the difference in values (1 L = 1000 m^-3)
  [water2]
    #species = 'em_aq H3Op_aq H_aq H2O2_aq OH_aq OHm_aq O2_aq O2m_aq O_aq Om_aq H2_aq HO2_aq HO2m_aq H2Op_aq O3m_aq O3_aq HO3_aq NO_aq NO2_aq NO3_aq NO2m_aq NO3m_aq OONOm_aq HNO2_aq HNO3_aq HOONO_aq N2O3_aq N2O4_aq N2O5_aq'
    species = 'em_aq H3Op_aq H_aq H2O2_aq OH_aq OHm_aq O2_aq O2m_aq O_aq Om_aq H2_aq HO2_aq HO2m_aq H2Op_aq O3m_aq O3_aq HO3_aq NO_aq NO2_aq NO3_aq NO2m_aq NO3m_aq HNO2_aq HNO3_aq N2O3_aq N2O4_aq N2O5_aq'
    aux_species = 'H2O_aq'
    use_log = true
    position_units = ${dom1Scale}
    track_rates = false
    reaction_coefficient_format = 'rate'
    block = 1

    reactions = 'em_aq + H2O_aq -> H_aq + OHm_aq            : 1.9e-2
                 #em_aq + H2Op_aq -> H_aq + OH_aq            : 6e-8 
                 em_aq + H2Op_aq -> H_aq + OH_aq            : 6e8 
                 # The units on this next one make no sense and have no consistency 
                 # across literature. This is the Buxton value (halved)
                 #em_aq + H_aq + H2O_aq -> H2_aq + OHm_aq    : 2.5e7
                 em_aq + OH_aq -> OHm_aq                    : 3e7
                 # where does this one come from???
                 #em_aq + em_aq + H2O_aq -> OHm_aq + OHm_aq  : 2.2e4
                 em_aq + H3Op_aq -> H_aq + H2O_aq                 : 2.3e7
                 em_aq + H2O2_aq -> OH_aq + OHm_aq                : 1.1e7 
                 #em_aq + HO2m_aq + H2O_aq -> OH_aq + OHm_aq + OHm_aq     : 3.5e3
                 em_aq + HO2m_aq -> OH_aq + OHm_aq + OHm_aq   : 3.5e6
                 em_aq + O2_aq -> O2m_aq                        : 1.9e7
                 # Next one is approximated by analogy (probably wrong...)
                 em_aq + O_aq -> Om_aq                          : 1.9e7
                 # This one is listed as 1e10 in Chens work. Completely different.
                 # I am going with this value because I have seen it in multiple references.
                 H_aq + OH_aq -> H2O_aq                        : 7e6
                 H_aq + OHm_aq -> em_aq + H2O_aq                  : 2.2e4
                 H_aq + H2O2_aq -> OH_aq + H2O_aq                 : 9e4
                 H_aq + O2_aq -> HO2_aq                        : 2.1e7
                 H_aq + HO2_aq -> H2O2_aq                      : 1e7
                 O_aq + H2O_aq -> OH_aq + OH_aq                   : 1.3e1
                 O_aq + O2_aq -> O3_aq                         : 3e6
                 OH_aq + OH_aq -> H2O2_aq    : 5.5e6
                 OH_aq + Om_aq -> HO2m_aq    : 2e7
                 OH_aq + OHm_aq -> Om_aq + H2O_aq   : 1.3e7
                 OH_aq + HO2_aq -> H2O_aq + O2_aq   : 6e6
                 OH_aq + O2m_aq -> OHm_aq + O2_aq     : 8e6
                 Om_aq + H2O_aq -> OHm_aq + OH_aq     : 1.8e3
                 Om_aq + H2O2_aq -> O2m_aq + H2O_aq   : 5e5
                 Om_aq + HO2m_aq -> O2m_aq + OHm_aq   : 4e5
                 Om_aq + O2_aq -> O3m_aq           : 3.6e6
                 #Om_aq + O2m_aq + H2O_aq -> OHm_aq + OHm_aq + O2_aq   : 6e2
                 Om_aq + O2m_aq -> OHm_aq + OHm_aq + O2_aq   : 6e5
                 OH_aq + H2O2_aq -> H2O_aq + HO2_aq     : 2.7e4
                 OH_aq + HO2m_aq -> OHm_aq + HO2_aq     : 7.5e6
                 # What the fuck
                 #H2Op_aq + H2O_aq -> OHm_aq + HO2_aq    : 6
                 H2Op_aq + H2O_aq -> H3Op_aq + OH_aq    : 6
                 H3Op_aq + OHm_aq -> H_aq + OH_aq + H2O_aq     : 6e7
                 HO2_aq + H2O_aq -> H3Op_aq + O2m_aq        : 2
                 H3Op_aq + O2m_aq -> HO2_aq + H2O_aq        : 6e-2
                 ##################################
                 # HYDROGEN REACTIONS
                 ##################################
                 em_aq + em_aq -> H2_aq + OHm_aq + OHm_aq   : 5.5e6 
                 em_aq + H_aq -> H2_aq + OHm_aq             : 2.5e7
                 H_aq + H2O_aq -> H2_aq + OH_aq                   : 1e-2
                 H_aq + H_aq -> H2_aq                          : 7.5e6
                 H2_aq + H2O2_aq -> H_aq + OH_aq + H2O_aq            : 6e3
                 OH_aq + H2_aq -> H_aq + H2O_aq     : 4.2e4
                 Om_aq + H2_aq -> OHm_aq + H_aq       : 8e7
                 ##################################
                 # Additional reactions from Chen
                 #
                 # Some of these are from: 
                 # Elliot, A. John and McCracken, David R. "Computer modelling 
                 # of the radiolysis in an aqueous lithium salt blanket: 
                 # Suppression of radiolysis by addition of hydrogen." 
                 # Fusion Engineering and Design 13 (1990) 21-27
                 # doi: 10.1016/0920-3796(90)90028-5 
                 # 
                 # Note the reactions with H2O are often given with wrong
                 # (or confusing) rate coefficients. 
                 # e.g. k = 1.3e10 / [H2O] - 
                 # this means that the rate coefficient is essentially
                 # for a two body reaction since H2O is already included
                 #################################
                 O_aq + O_aq -> O2_aq          : 2.8e7
                 em_aq + O2m_aq + H2O_aq -> HO2m_aq + OHm_aq   : 1.3e4
                 em_aq + HO2_aq -> HO2m_aq     : 2e7
                 em_aq + O2_aq -> O2m_aq       : 1.9e7
                 #em_aq + Om_aq + H2O_aq -> OHm_aq + OHm_aq     : 2.2e4
                 # This one is listed with conflicting units in literature. 
                 # (Three body reaction with a two body reaction rate coefficient.)
                 em_aq + Om_aq -> OHm_aq + OHm_aq       : 2.2e7
                 #em_aq + O3m_aq + H2O_aq -> O2_aq + OHm_aq + OHm_aq   : 1.6e4 
                 em_aq + O3m_aq -> O2_aq + OHm_aq + OHm_aq : 1.6e7
                 em_aq + O3_aq -> O3m_aq     : 3.6e7
                 H_aq + Om_aq -> OHm_aq      : 1.1e7
                 H_aq + HO2m_aq -> OHm_aq + OH_aq   : 9e7 
                 H_aq + O3m_aq -> OHm_aq + O2_aq    : 1e7
                 H_aq + O2m_aq -> HO2m_aq        : 1.8e7
                 # Include HO3_aq or no?
                 H_aq + O3_aq -> HO3_aq          : 3.8e7 
                 OH_aq + O3m_aq ->  O3_aq + OHm_aq    : 2.6e6
                 #OH_aq + O3m_aq -> O2_aq + O2_aq + Hp     : 6e6
                 OH_aq + O3_aq -> HO2_aq + O2_aq          : 1.1e5
                 HO2_aq + O2m_aq -> HO2m_aq + O2_aq       : 8e4
                 HO2_aq + HO2_aq -> H2O2_aq + O2_aq       : 7e2
                 HO2_aq + Om_aq -> O2_aq + OHm_aq         : 6e6
                 HO2_aq + H2O2_aq -> OH_aq + O2_aq + H2O_aq    : 5e-4
                 HO2_aq + HO2m_aq -> OHm_aq + OH_aq + O2_aq    : 5e-4
                 O2m_aq + O2m_aq -> H2O2_aq + O2_aq + OHm_aq + OHm_aq : 1e-1
                 Om_aq + O2m_aq -> OHm_aq + OHm_aq + O2_aq       : 6e5
                 O2m_aq + H2O2_aq -> OH_aq + O2_aq + OHm_aq            : 1.3e-4
                 O2m_aq + HO2m_aq -> Om_aq + O2_aq + OHm_aq            : 1.3e-4
                 #O2m_aq + O3m_aq + H2O_aq -> OHm_aq + OHm_aq + O2_aq + O2_aq : 1e1 
                 O2m_aq + O3m_aq -> OHm_aq + OHm_aq + O2_aq + O2_aq   : 1e1
                 O2m_aq + O3_aq -> O3m_aq + O2_aq      : 1.5e6
                 Om_aq + Om_aq -> OHm_aq + HO2m_aq    : 1e6 
                 O3m_aq + H_aq -> O2_aq + OH_aq       : 9e7
                 O_aq + OHm_aq -> HO2m_aq          : 1.1e2
                 O_aq + H2O2_aq -> OH_aq + HO2_aq     : 1.6e5
                 O_aq + HO2m_aq -> OH_aq + O2m_aq     : 5.3e6
                 O3_aq + H2O2_aq -> OH_aq + HO2_aq + O2_aq   : 3e9
                 #HO3_aq -> O2_aq + OH_aq           : 1e2
                 O3m_aq + H3Op_aq -> O2_aq + OH_aq + H2O_aq      : 9e7
                 HO3_aq -> O2_aq + OH_aq          : 1.1e5
                 H2O2_aq -> OH_aq + OH_aq               : 4.4e-9
                 HO2m_aq -> Om_aq + OH_aq         : 1e-5
                 ############################################
                 # Aqueous reactions involving nitrogen
                 ############################################
                 OH_aq + NO2m_aq -> OHm_aq + NO2_aq     : 1e7
                 #H2O2_aq + NO2m_aq -> OONOm_aq + H2O_aq   : 4.5e5
                 H_aq + NO2m_aq -> OHm_aq + NO_aq         : 1.2e6
                 Om_aq + NO2m_aq + H2O_aq -> OHm_aq + OHm_aq + NO2_aq     : 3.6e5
                 NO_aq + NO_aq + O2_aq -> NO2_aq + NO2_aq              : 2.3e3
                 NO_aq + NO2_aq + H2O_aq -> HNO2_aq + HNO2_aq          : 2e5
                 H_aq + HNO2_aq -> NO_aq + H2O_aq         : 4.5e5
                 NO_aq + OH_aq -> HNO2_aq        : 2e7
                 NO2_aq + H_aq -> HNO2_aq       : 1e7
                 HNO3_aq + OH_aq -> NO3_aq + H2O_aq   : 1.2e5
                 NO_aq + HO2_aq -> HNO3_aq     : 8e6
                 NO2_aq + OH_aq -> HNO3_aq     : 3e7
                 O2m_aq + NO_aq -> NO3m_aq     : 1.6e7
                 #NO_aq + HO2_aq -> HOONO_aq      : 3.2e6
                 #NO2_aq + OH_aq -> HOONO_aq      : 1.2e7
                 #O2m_aq + NO_aq -> OONOm_aq      : 6.6e6
                 HNO2_aq + H2O_aq -> H3Op_aq + NO2m_aq    : 1.8e-2
                 H3Op_aq + NO2m_aq -> HNO2_aq + H2O_aq    : 2
                 H3Op_aq + NO3m_aq -> HNO3_aq + H2O_aq    : 2e-1
                 # The next three have strange units. Why M^-2 (m^6) when there
                 # are only two reactants?
                 # I only reduced by a factor of 1e-3 instead of 1e-6 to match
                 # the reactants. 
                 N2O3_aq + H2O_aq -> HNO2_aq + HNO2_aq      : 1.1e-1
                 N2O4_aq + H2O_aq -> HNO2_aq + HNO3_aq      : 8e-1
                 N2O5_aq + H2O_aq -> HNO3_aq + HNO3_aq      : 1.2e-3
                 NO2_aq + NO2_aq + H2O_aq -> HNO2_aq + H3Op_aq + NO3m_aq    : 1.5e2
                 NO2_aq + NO2_aq + H2O_aq -> H3Op_aq + NO2m_aq + H3Op_aq + NO3m_aq   : 5e1'
  []

  # More comprehensive reaction network is available in "Air plasma treatment
  # of liquid covered tissue: long timescale chemistry" 
  # Lietz et al. J. Phys. D: Appl. Phys. 49 425204 (2016)
[]