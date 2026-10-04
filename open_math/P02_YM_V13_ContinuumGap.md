# P02-YM V13 — Continuum Gap Frontier

## Certified finite side

- GAP_CONCRETE_GREEN: 4c18b61f8e080928073c6312efc06477c0dfc37f
- RUN: 37199887193 SUCCESS
- FINITE_SPECTRAL_GREEN_BASE: 555bdff21f3c738ae5aa61063ef904035a3e91dc
- RUN: 37200380539 SUCCESS
- PARSEVAL_GREEN: 1268b0eefce02b0409dc5ccd47d9b05c9ed3e7e9
- RUN: 37200888486 SUCCESS
- EXPECTATION_GREEN: 1f97a1527273cc0eb2c437d4be46e816c4a5a843
- RUN: 37201241922 SUCCESS
- FINITE_MASS_GAP_GREEN: 780beda711296d36834112627a7847ad3564e9b2
- RUN: 37201886885 SUCCESS

## Closed chain

FiniteRegulatedHamiltonianV13
→ eigenbasis / eigenvalue
→ spectralWeight
→ massBelowFinite
→ spectralWeight_sum
→ spectralWeight_expectation
→ spectralWeight_eq_zero_of_eigenvalue_lt
→ finite_mass_gap_of_vanishing_below

## Exact remaining open math

The remaining producer is NOT finite spectral algebra.

It is regulator-to-continuum control strong enough to transport the spectral
lower-edge statement while preserving the same physical state and Hamiltonian.

Pointwise convergence

  massBelowFinite R psi r → massBelowContinuum psi r

is insufficient by itself: continuum vanishing at r < m does not imply
massBelowFinite R psi r = 0 for each finite R.

A sufficient producer must provide a genuinely quantitative bridge, e.g. one
of the following forms (or a provably equivalent material theorem):

1. eventual exact low-spectrum exclusion:
   for every psi and r < m, eventually in R,
   massBelowFinite R psi r = 0;

2. monotone support preservation plus convergence:
   finite low-energy support cannot appear below a continuum gap;

3. uniform spectral control strong enough to pass the lower spectral edge
   from regulators to the continuum Hamiltonian.

The bridge must also preserve the finite norm and energy limits used by the
quadratic-form inequality.

OPEN_MATH = 1
NEXT_PRODUCER = REGULATOR_TO_CONTINUUM_SPECTRAL_GAP_TRANSFER

This file does not claim an unconditional Yang-Mills mass gap.
