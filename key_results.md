# Key Results

## Baseline design

- Beam: 1.5 m cantilever, 50 mm × 100 mm rectangular section
- Material properties used: E = 69 GPa, yield strength = 276 MPa
- End point load: 2.5 kN
- Maximum bending moment: 3.75 kN·m
- Maximum bending stress: 45.00 MPa
- Maximum deflection: 9.78 mm
- Yield factor of safety: 6.13
- Maximum strain: 652.17 microstrain
- Maximum slope: 0.00978 rad = 0.5605°
- Yield-load capacity: 15.33 kN
- Deflection-based load limit for 5 mm tip deflection: 1.278 kN
- Stress utilization: 16.30%
- Deflection utilization: 195.65%

## Baseline design decision

- Yield check: PASS
- 5 mm deflection check: FAIL
- Overall design: FAIL
- Governing criterion: Deflection / stiffness

The original section has a substantial strength margin but does not satisfy the serviceability requirement.

## Analytical sizing

- Height required at the yield boundary: 40.38 mm
- Height required by the 5 mm deflection limit: 125.07 mm
- Governing analytical height: 125.07 mm
- Governing criterion: Deflection / stiffness

The strength-based height corresponds to the onset of yielding and is not a production design safety-factor requirement.

## Redesign validation

For a fixed width of 50 mm and analytical height of 125.07 mm:

- Redesigned maximum stress: 28.77 MPa
- Redesigned maximum deflection: 5.00 mm
- Redesigned yield factor of safety: 9.59
- Redesigned deflection utilization: 100.00%
- Height increase: 25.07%
- Stress reduction: 36.07%
- Deflection reduction: 48.89%

## Parametric design study

- Height range: 60 mm to 150 mm
- Number of candidate geometries: 50
- First discrete design satisfying both strength and deflection constraints: 126.12 mm
- Maximum stress at first feasible discrete design: approximately 28.29 MPa
- Maximum deflection at first feasible discrete design: approximately 4.88 mm
- Difference between analytical and first feasible discrete height: approximately 0.84%

The analytical sizing result and the independent discrete parametric search agree closely, providing an internal consistency check on the design logic.
