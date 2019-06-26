"""
CES aggregator of the form

Y = A * [sum of (alpha X) ^ rho] ^ (1/rho)
Q = sum of (alpha X) ^ rho

Accommodates matrix inputs (T x N)

Best to store AV in the object
- little cost in terms of efficiency
- consistency ensured
"""

## Type definition
# should be subtype of production function +++
mutable struct CES
  substElast :: Float64
  # relative weights; Nx1
  alphaV :: Vector{Float64}
  # Productivities
  AV :: Vector{Float64}
  # # Data, TxN
  # xM :: Matrix{Float64}
  # Derived objects. Useful to precompute
  rho :: Float64
  qV :: Vector{Float64}

  # ----  Constructor
  # enforces consistency
  function CES(sElast :: Float64, aV :: Vector{Float64}, prodV :: Vector{Float64})
    fS = new();
    set_params(fS, substElast = sElast, alphaV = aV, AV = prodV);
    return fS
  end
end


# ----  Check a CES
function check(this :: CES)
    # T, n = size(fS.xM);
    check_subst_elast(this.substElast)
    # check more +++
end

function check_subst_elast(substElast :: Float64)
    @assert (length(substElast) == 1)
    @assert (substElast > 0.01  &&  substElast < 50)
end


## Set parameters in CES
function set_params(fS :: CES;  substElast = [], alphaV = [], AV = [])
  # Assign, then check consistency
  if !isempty(substElast)
    fS.substElast = substElast;
  end
  if !isempty(alphaV)
    fS.alphaV = alphaV;
  end
  if !isempty(AV)
    fS.AV = AV;
  end
  # if !isempty(xM)
  #   fS.xM = xM;
  # end

  # Derived
  fS.rho = 1.0 - 1.0 / fS.substElast;

  check(fS);
end


# # ----  return rho from subst elast
# function ces_rho(fS :: CES)
#   return 1.0 / fS.substElast - 1.0;
# end


## -------  Returns sum(alpha * x ^ rho) ^ (1/rho)
function ces_q(alphaV :: Vector{Float64}, xM :: Matrix{Float64}, rho :: Float64)
  T = size(xM, 1);
  qV = zeros(Float64, T);
  for t = 1 : T
      # Careful here: alphaV * xM could become a matrix
      qV[t] = sum((alphaV .* xM[t,:]) .^ rho);
  end
  return qV
end


## -------  Output
function output(fS :: CES, xM :: Matrix{Float64})
    qV = ces_q(fS.alphaV, xM, fS.rho);
    return fS.AV .* (qV .^ (1 / fS.rho));
end


## --------  Marginal products (TxN)
function mproducts(fS :: CES, xM :: Matrix{Float64})
  T = length(fS.AV)
  N = length(fS.alphaV);
  # qV is T x 1
  qV = ces_q(fS.alphaV, xM, fS.rho);
  rho = fS.rho;
  aqV = fS.AV .* (qV .^ (1 / rho - 1));
  # mpM = similar(xM);
  # for j = 1 : N
  #   mpM[:,j] = aqV .* (fS.alphaV[j] .^ rho) .* (xM[:,j] .^ (rho - 1));
  # end
  mpM = aqV .* (xM .^ (rho-1)) .* (fS.alphaV .^ rho)';
  # @assert (all(abs.(mp2M - mpM) .< 1e-5))
  return mpM
end
