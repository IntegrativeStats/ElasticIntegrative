% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/elasticHTE.R, R/s3_methods.R
\name{elasticHTE}
\alias{elasticHTE}
\alias{print.elasticHTE}
\alias{summary.elasticHTE}
\title{Elastic Integrative Analysis for Heterogeneous Treatment Effect}
\usage{
elasticHTE(
  data.rct,
  data.rwe,
  ...,
  outcome.type = c("cont", "bin"),
  ps.rct = NULL,
  sieve.degree = 2L,
  outcome.method = c("glm", "SL"),
  outcome.controls = list(family = "gaussian"),
  ps.method = c("glm", "SL"),
  ps.controls = list(family = "quasibinomial"),
  n.pert = 100L,
  fixed = FALSE,
  n.gamma = 1000L,
  n.boot = 100L,
  thres.psi = NULL
)

\method{print}{elasticHTE}(x, ...)

\method{summary}{elasticHTE}(object, ...)
}
\arguments{
\item{data.rct}{The value object returned by \code{dataInput()} for the
data from a randomized clinical trial (RCT). See \link{dataInput} for
further details.}

\item{data.rwe}{The value object returned by \code{dataInput()} for the
data from a real-world evidence (RWE) study. See \link{dataInput} for
further details. Note that the treatment effect model must be identical
to that of \code{data.rct}.}

\item{...}{Ignored}

\item{outcome.type}{A character. The type of outcome. Must be one of
\{"cont", "bin"\} indicating a continuous or binary outcome, respectively.}

\item{ps.rct}{NULL or a numeric vector. Optional input providing a vector of
known propensity scores P(A=1) for the RCT dataset. If not provided,
it will be estimated using the model defined in \code{data.rct$psName}.}

\item{sieve.degree}{A positive integer > 1. The order of the polynomial
defining the sieve model. For example, \code{sieve.degree = 2} yields outcome and
propensity models that include all covariates, the squared covariates, and
all pair-wise interactions.}

\item{outcome.method}{A character. The regression method for outcomes.
Must be one of \{"glm", "SL"\}. The outcome is modeled without adjustment,
so method and family must be appropriate for the outcome.type.}

\item{outcome.controls}{A named list. Additional inputs provided to
\code{stats::glm()} or
\code{SuperLearner::SuperLearner()} for the outcome regression analyses.
Element names must match the formal arguments of \code{stats::glm()} or
\code{SuperLearner::SuperLearner()} and should include, at a minimum,
element "family". Please see ?stats::glm or ?SuperLearner::SuperLearner
for additional input options.}

\item{ps.method}{A character. The regression method for propensity score
analysis. Must be one of \{"glm", "SL"\}.}

\item{ps.controls}{A named list. Additional inputs provided to
\code{stats::glm()} or
\code{SuperLearner::SuperLearner()} for the propensity score regression analyses.
Element names must match the formal arguments of \code{stats::glm()} or
\code{SuperLearner::SuperLearner()} and should include, at a minimum,
element "family". Please see ?stats::glm or ?SuperLearner::SuperLearner
for additional input options.}

\item{n.pert}{An integer. The number of perturbations to generate when
estimating the variance.}

\item{fixed}{A logical. How to select the tuning parameter
\eqn{c_{\gamma}}{c_gamma}. FALSE, the default, selects an adaptive
selection strategy; TRUE selects a fixed threshold strategy.
The default fixed threshold is \code{stats::qchisq(0.95, df = p)},
in which p is the dimension of the treatment effect model.}

\item{n.gamma}{An integer. The number of samples to generate to estimate
\eqn{c_{\gamma}}{c_gamma}, the threshold.}

\item{n.boot}{An integer. The number of bootstrap samples to generate
when estimating the confidence intervals.}

\item{thres.psi}{NULL or a scalar numeric. The threshold for constructing
adaptive confidence intervals. If NULL, a default value of
\eqn{\sqrt{\log(n)}}{sqrt(log(n))}, where n is the number of participants
in \code{data.rwe}, is used.}

\item{x}{An object of S3 class \code{elasticHTE}.}

\item{object}{An object of S3 class \code{elasticHTE}.}
}
\value{
A list with components:
\item{psi }{A matrix containing the estimated \eqn{\psi}{`psi`} associated
with the treatment modifiers under various models
(\eqn{\psi_p}{`psi_p`}, \eqn{\psi_{eff}}{`psi_eff`}, \eqn{\psi_{rt}}{`psi_rt`},
and \eqn{\psi_{elastic}}{`psi_elastic`}).}
\item{ve }{A matrix containing the estimated standard error for
\eqn{\psi}{`psi`}.}
\item{CIs.inf, CIs.sup }{A matrix containing the estimated confidence
intervals for \eqn{\psi}{`psi`}.}
\item{CI.settings }{A list of the settings used in the confidence interval
procedure.}
\item{Tstat }{The estimated test statistic.}
\item{conservative }{A logical \eqn{I(Tstat < thres.psi)}{I(Tstat < thres.psi)} }
\item{nuispar }{A list providing the selected \eqn{\gamma}{gamma} and
its corresponding threshold value \eqn{c_{\gamma}}{c.gamma};
indicator \eqn{I(c_{\gamma}  > Tstat)}{I(c.gamma > Tstat)} and its
p-value; eta, where \eqn{Tstat = \eta^T \eta}{Tstat = eta^T eta};
and a list of the settings used in the selection procedure.}
}
\description{
A test-based dynamic borrowing framework combining
a randomized clinical trial (RCT) and a real-world evidence (RWE) study,
in which a preliminary test statistic is used to gauge the comparability
and reliability of the RWE and to decide whether or not to use the RWE in
an integrative analysis. The parameter of interest is \eqn{\psi}{`psi`},
which quantifies how the treatment effect varies over the treatment
modifiers.
}
\details{
Inputs \code{data.rct} and \code{data.rwe} are most easily specified using
the provided convenience function \link{dataInput}(). However, this is
not required. See \link{dataInput}() for details of the returned
object.
}
\section{Methods (by generic)}{
\itemize{
\item \code{print(elasticHTE)}: Print summary of analysis

\item \code{summary(elasticHTE)}: Summary of analysis.

}}
\note{
When specifying \code{outcome.controls} and \code{ps.controls}, some
input arguments cannot be accessed. Specifically, formal arguments
\code{Y}, \code{X}, \code{newX}, and  \code{obsWeight} of
\code{SuperLearner::SuperLearner()} and \code{formula}, \code{data}, and
\code{weights} of \code{stats::glm()} cannot be set through these inputs.
}
\examples{
# Note that n.gamma and n.pert are smaller than recommended to accommodate
# fast examples.
#
# load provided illustrative toy dataset with continuous outcome
data("elasticToy.cont")

# conduct the elastic integrative analysis with defaults
result.cont <- elasticHTE(data.rct = dataInput(elasticToy.cont.rct,
                                               outcome.model = Y ~ (X1+X2)*A,
                                               ps.model = A ~ X1 + X2),
                          data.rwe = dataInput(elasticToy.cont.rwe,
                                               outcome.model = Y ~ (X1+X2)*A,
                                               ps.model = A ~ X1 + X2),
                          n.boot = 0L, n.gamma = 10L, n.pert = 10L)

# load provided illustrative toy dataset with binary outcome
data("elasticToy.bin")

# conduct the elastic integrative analysis with defaults
result.bin <- elasticHTE(data.rct = dataInput(elasticToy.bin.rct,
                                              outcome.model = Y ~ (X1+X2)*A,
                                              ps.model = A ~ X1 + X2),
                         data.rwe = dataInput(elasticToy.bin.rwe,
                                              outcome.model = Y ~ (X1+X2)*A,
                                              ps.model = A ~ X1 + X2),
                         outcome.type = "bin",
                         n.boot = 0L, n.gamma = 10L, n.pert = 10L)

}
