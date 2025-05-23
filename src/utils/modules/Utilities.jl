"""
    Utilities

This module contains utility functions for the IESopt package, that can be helpful in preparing or analysing components.
"""
module Utilities

import ..IESopt
import ..IESopt: @critical
import ArgCheck: @argcheck
import JuMP

public annuity
public timespan
public yearspan

"""
    annuity(total::Real; lifetime::Real, rate::Float64, fraction::Float64)

Calculate the annuity of a total amount over a lifetime with a given interest rate.

# Arguments

- `total::Real`: The total amount to be annuitized.

# Keyword Arguments

- `lifetime::Real`: The lifetime over which the total amount is to be annuitized.
- `rate::Float64`: The interest rate at which the total amount is to be annuitized.
- `fraction::Float64`: The fraction of a year that the annuity is to be calculated for (default: 1.0).

# Returns

`Float64`: The annuity of the total amount over the lifetime with the given interest rate.

# Example

Calculating a simple annuity, for a total amount of € 1000,- over a lifetime of 10 years with an interest rate of 5%:

```julia
# Set a parameter inside a template.
set("capex", IESU.annuity(1000.0; lifetime=10, rate=0.05))
```

Calculating a simple annuity, for a total amount of € 1000,- over a lifetime of 10 years with an interest rate of 5%,
for a fraction of a year (given by `MODEL.yearspan`, which is the total timespan of the model in years):
    
```julia
# Set a parameter inside a template.
set("capex", IESU.annuity(1000.0; lifetime=10, rate=0.05, fraction=MODEL.yearspan))
```
"""
function annuity(total::Real; lifetime::Real, rate::Float64, fraction::Float64=1.0)::Float64
    @argcheck total >= 0
    @argcheck 0 < lifetime < 1e3
    @argcheck 0.0 < rate < 1.0
    @argcheck fraction > 0
    if fraction > 1
        @warn "[annuity] The fraction is greater than 1, which may not be intended."
    end
    return total * rate / (1 - (1 + rate)^(-lifetime)) * fraction
end

function annuity(total::Real, lifetime::Real, rate::Real)
    msg = "[annuity] Error trying to call `annuity($(total), $(lifetime), $(rate))`"
    reason = "`lifetime` and `rate` must be passed as keyword arguments to `annuity(...)`"
    example = "`annuity(1000.0; lifetime=10, rate=0.05)`"
    @critical msg reason example
end

function annuity(total::Real, lifetime::Real, rate::Real, fraction::Real)
    msg = "[annuity] Error trying to call `annuity($(total), $(lifetime), $(rate), $(fraction))`"
    reason = "`lifetime`, `rate`, and `fraction` must be passed as keyword arguments to `annuity(...)`"
    example = "`annuity($(total); lifetime=$(lifetime), rate=$(rate), fraction=$(fraction))`"
    @critical msg reason example
end

"""
    timespan(model::JuMP.Model)::Float64

Calculate the total timespan (duration, time period, ...) of a model in hours.

# Arguments

- `model::JuMP.Model`: The model for which the timespan is to be calculated.

# Returns

`Float64`: The total timespan of the model in hours.
"""
function timespan(model::JuMP.Model)::Float64
    return sum(s.weight for s in values(IESopt._iesopt_model(model).snapshots))
end

"""
    yearspan(model::JuMP.Model)::Float64

Calculate the total timespan (duration, time period, ...) of a model in years. This assumes that a full year has a total
of 8760 hours.

# Arguments

- `model::JuMP.Model`: The model for which the timespan is to be calculated.

# Returns

`Float64`: The total timespan of the model in years.
"""
function yearspan(model::JuMP.Model)::Float64
    return timespan(model) / 8760.0
end

end
