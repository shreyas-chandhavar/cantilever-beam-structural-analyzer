# Cantilever Beam Structural Load & Design Analyzer — MATLAB

A MATLAB engineering analysis project for a rectangular cantilever beam subjected to an end point load. The model goes beyond a single stress calculation: it evaluates structural response, checks strength and serviceability, calculates allowable loads, sizes the section, validates a redesign, and performs a parametric height study to identify a feasible design.

## Engineering problem

A 1.5 m aluminium cantilever beam with a 50 mm × 100 mm rectangular cross-section is subjected to a 2.5 kN point load at the free end.

The analysis asks two separate design questions:

1. **Strength:** Is the maximum bending stress below the material yield strength?
2. **Serviceability:** Is the maximum tip deflection below an allowable limit of 5 mm?

This distinction becomes important because the baseline beam is safe against yielding but fails the deflection requirement.

## Baseline inputs

| Parameter | Value |
|---|---:|
| Beam length, `L` | 1.50 m |
| Width, `b` | 50 mm |
| Height, `h` | 100 mm |
| Young's modulus, `E` | 69 GPa |
| End load, `F` | 2.50 kN |
| Yield strength | 276 MPa |
| Allowable deflection | 5 mm |

## Analytical model

For the rectangular section:

```text
I = b h^3 / 12
c = h / 2
Z = I / c
```

For a cantilever with an end point load:

```text
M(x)     = F(L - x)
sigma(x) = M(x)c / I
y(x)     = F x^2 (3L - x) / (6EI)
theta(x) = F x (2L - x) / (2EI)
```

The model also calculates support reactions, shear force, bending strain, factor of safety, critical locations, yield-load capacity and deflection-based load capacity.

## Baseline results

| Output | Result |
|---|---:|
| Maximum bending stress | **45.00 MPa** |
| Maximum deflection | **9.78 mm** |
| Yield factor of safety | **6.13** |
| Maximum strain | **652.17 µε** |
| Maximum slope | **0.5605°** |
| Yield-load capacity | **15.33 kN** |
| Deflection-based load limit | **1.278 kN** |
| Stress utilization | **16.30%** |
| Deflection utilization | **195.65%** |

### Baseline design decision

- **Yield check:** PASS
- **5 mm deflection check:** FAIL
- **Overall design:** FAIL
- **Governing criterion:** **Deflection / stiffness**

The result illustrates an important structural-design point: a component can have a high factor of safety against yielding and still be unacceptable because of excessive deformation.

## Structural response

### Bending moment distribution

![Bending moment distribution](figures/figure1_bending_moment.png)

The maximum bending moment occurs at the fixed support and decreases linearly to zero at the free end.

### Bending stress distribution

![Bending stress distribution](figures/figure2_bending_stress.png)

The maximum bending stress is 45 MPa at the fixed support.

### Beam deflection

![Beam deflection distribution](figures/figure3_deflection.png)

The maximum deflection occurs at the free end and reaches approximately 9.78 mm.

## Design sizing

The required beam height is calculated independently from strength and deflection constraints.

### Strength requirement

```text
h_strength = sqrt(6 F L / (b sigma_y))
```

Result:

**h_strength = 40.38 mm**

### Deflection requirement

Using the rectangular-section moment of inertia in the cantilever tip-deflection equation:

```text
h_deflection = [4 F L^3 / (E b y_allow)]^(1/3)
```

Result:

**h_deflection = 125.07 mm**

Therefore:

**Required height = max(h_strength, h_deflection) = 125.07 mm**

The redesign is governed by **deflection**, not material strength.

## Redesign validation

Keeping the width fixed at 50 mm and increasing the height to the analytically required value gives:

| Metric | Original | Redesigned |
|---|---:|---:|
| Beam height | 100 mm | 125.07 mm |
| Maximum stress | 45.00 MPa | 28.77 MPa |
| Maximum deflection | 9.78 mm | 5.00 mm |
| Yield factor of safety | 6.13 | 9.59 |
| Deflection utilization | 195.65% | 100.00% |

Design changes:

- Height increase: **25.07%**
- Stress reduction: **36.07%**
- Deflection reduction: **48.89%**

## Parametric design study

A 50-point study evaluates beam heights from 60 mm to 150 mm. For each candidate geometry MATLAB recalculates:

- second moment of area
- maximum bending stress
- maximum deflection
- factor of safety
- strength feasibility
- serviceability feasibility

The first discrete design satisfying both constraints is approximately **126.12 mm**, which closely agrees with the analytical sizing result of **125.07 mm**.

![Effect of beam height on maximum deflection](figures/figure4_height_deflection_study.png)

The nonlinear decrease in deflection reflects the strong relationship:

```text
y_max ∝ 1 / h^3
```

## Original vs redesigned performance

![Original vs redesigned beam performance](figures/figure5_original_vs_redesigned.png)

The utilization plot makes the governing design constraint explicit: the original section uses only about 16% of its yield capacity but nearly 196% of the allowable deflection.

## MATLAB concepts used

- vectors and element-wise operations
- logical indexing and critical-location extraction
- `max`, `min`, `find` and array indices
- conditional statements
- `for` loops
- preallocation with `zeros`
- formatted engineering output with `fprintf`
- engineering plots and design-limit visualization
- parametric design-space exploration

## Repository structure

```text
Cantilever-Beam-Structural-Analyzer/
├── cantilever_beam_structural_analyzer.m
├── README.md
├── LICENSE
├── .gitignore
├── figures/
│   ├── figure1_bending_moment.png
│   ├── figure2_bending_stress.png
│   ├── figure3_deflection.png
│   ├── figure4_height_deflection_study.png
│   └── figure5_original_vs_redesigned.png
└── results/
    ├── key_results.md
    └── matlab_workspace_results.pdf
```

PDF versions of the five figures are also included in `figures/`.

## Running the model

1. Open MATLAB or MATLAB Online.
2. Open `cantilever_beam_structural_analyzer.m`.
3. Modify the input parameters at the top of the script if required.
4. Run the full script.
5. Review the Command Window, Workspace and generated figures.

No specialized MATLAB toolboxes are required for the current implementation.

## Assumptions and limitations

The model is an analytical Euler–Bernoulli beam representation and assumes:

- linear-elastic material behavior
- small deflection
- constant rectangular cross-section
- prismatic beam
- ideal fixed support
- point load at the free end
- bending-dominated response

The current model does not include shear deformation, geometric nonlinearity, buckling, fatigue, stress concentrations, distributed loading or finite-element validation.

## Engineering takeaway

The central result is not simply the 45 MPa bending stress. The analysis demonstrates that **strength and stiffness must be assessed independently**. Although the initial beam has a yield FoS of approximately 6.13, its 9.78 mm tip deflection violates the 5 mm serviceability requirement. Analytical sizing and a 50-point parametric study both indicate that increasing the section height to approximately 125–126 mm resolves the governing stiffness constraint.

## License

Released under the MIT License.
