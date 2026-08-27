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
