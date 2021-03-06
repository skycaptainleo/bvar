#' Metropolis-Hastings settings
#'
#' Function to provide settings for the Metropolis-Hastings step in
#' \code{\link{bvar}}. Options include scaling the inverse Hessian that
#' is used to draw parameter proposals and automatic scaling to
#' achieve a certain acceptance rate.
#'
#' Note that adjustment of the acceptance rate by scaling the parameter draw
#' variability can only be done during the burn-in phase, as the resulting
#' draws do not feature the desirable properties of a Markov chain.
#' After the parameter draws have been scaled some additional draws should be
#' burnt, to ensure the chain has reached a high-probability region.
#'
#' @param scale_hess Numeric scalar or vector. Scaling parameter, determining
#' the range of hyperparameter draws. \strong{Should be calibrated so a
#' reasonable rate of acceptance is reached}. If provided as vector the length
#' must equal the number of hyperparameters (one per variable for \code{psi}).
#' @param adjust_acc Logical scalar. Whether or not to further scale the
#' variability of parameter draws during the burn-in phase.
#' @param adjust_burn Numeric scalar. How much of the burn-in phase should be
#' used to scale parameter variability. See Details.
#' @param acc_lower,acc_upper Numeric scalar. Lower (upper) bound of the target
#' acceptance rate. Required if \emph{adjust_acc} is set to \code{TRUE}.
#' @param acc_change Numeric scalar. Percent change applied to the Hessian
#' matrix. Required if \emph{adjust_acc} is set to \code{TRUE}.
#'
#' @return Returns a named list of class \code{bv_metropolis} with options for
#' \code{\link{bvar}}.
#'
#' @keywords VAR BVAR MH metropolis-hastings acceptance mcmc
#'
#' @export
#'
#' @examples
#' # Only adjust the scale parameter
#' bv_mh(scale_hess = 10)
#'
#' # Turn on automatic scaling of the acceptance rate to [20%, 40%]
#' bv_mh(adjust_acc = TRUE, acc_lower = 0.2, acc_upper = 0.4)
#'
#' # Increase the rate of automatic scaling
#' bv_mh(adjust_acc = TRUE, acc_lower = 0.2, acc_upper = 0.4, acc_change = 0.1)
bv_metropolis <- function(
  scale_hess = 0.01,
  adjust_acc = FALSE,
  adjust_burn = 0.5,
  acc_lower = 0.25, acc_upper = 0.35,
  acc_change = 0.01) {

  scale_hess <- num_check(scale_hess, 1e-16, 1e16,
    "Issue with scale_hess, please check the parameter again.")

  if(adjust_acc) {
    adjust_burn <- num_check(adjust_burn, 1e-16, 1, "Issue with adjust_burn.")
    acc_lower <- num_check(acc_lower, 0, 1 - 1e-16, "Issue with acc_lower.")
    acc_upper <- num_check(acc_upper, acc_lower, 1, "Issue with acc_upper.")
    acc_change <- num_check(acc_change, 1e-16, 1e16, "Issue with acc_change")
  }

  out <- list(
    "scale_hess" = scale_hess,
    "adjust_acc" = adjust_acc, "adjust_burn" = adjust_burn,
    "acc_lower" = acc_lower, "acc_upper" = acc_upper,
    "acc_tighten" = 1 - acc_change, "acc_loosen" = 1 + acc_change
  )

  class(out) <- "bv_metropolis"

  return(out)
}


#' @rdname bv_metropolis
#' @export
bv_mh <- bv_metropolis
