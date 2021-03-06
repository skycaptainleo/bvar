% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/54_predict.R, R/55_fcast_print.R
\name{predict.bvar}
\alias{predict.bvar}
\alias{summary.bvar_fcast}
\title{Predict method for Bayesian VARs}
\usage{
\method{predict}{bvar}(object, ..., conf_bands, n_thin = 1L, newdata)

\method{summary}{bvar_fcast}(object, vars = NULL, ...)
}
\arguments{
\item{object}{A \code{bvar} object, obtained from \code{\link{bvar}}.
Summary and print methods take in a \code{bvar_fcast} object.}

\item{...}{A \code{bv_fcast} object or parameters to be fed into
\code{\link{bv_fcast}}. Contains settings for the forecast.}

\item{conf_bands}{Numeric vector of desired confidence bands to apply.
E.g. for bands at 5\%, 10\%, 90\% and 95\% set this to \code{c(0.05, 0.1)}.
Note that the median, i.e. \code{0.5} is always included.}

\item{n_thin}{Integer scalar. Every \emph{n_thin}'th draw in \emph{object}
is used for forecasting, others are dropped.}

\item{newdata}{Optional numeric matrix or dataframe. Used to base the
prediction on. Fitted values are used by default.}

\item{vars}{Optional numeric or character vector. Used to subset the summary
to certain variables by position or name (must be available). Defaults to
\code{NULL}, i.e. all variables.}
}
\value{
Returns a list of class \code{bvar_fcast} including forecasts
at desired confidence bands. See \code{\link{bvar}}.
The summary method returns a numeric array of forecast paths at the
specified confidence bands.
}
\description{
Retrieves / calculates forecasts for Bayesian VARs generated via
\code{\link{bvar}}. If a forecast is already present and no settings are
supplied it is simply retrieved, otherwise it will be calculated ex-post.
To store a prediction you may want to assign the output of
\code{predict.bvar} to \code{object$fcast}. May also be used to update
confidence bands.
}
\examples{
\donttest{
data <- matrix(rnorm(200), ncol = 2)
x <- bvar(data, lags = 2)

# Access forecast and update confidence bands
predict(x, conf_bands = 0.01)

# Adjust, compute and store a longer forecast
x$fcast <- predict(x, horizon = 24L)

# Lower draws, use `bv_fcast()` to set options and add confidence bands
predict(x, bv_fcast(24L), n_thin = 10L, conf_bands = c(0.05, 0.16))

# Use new data to calculate a prediction
predict(x, newdata = matrix(rnorm(200), ncol = 2))

# Get a summary of the last saved forecast
summary(x)

# Limit the summary to variable #2
summary(x, vars = 2L)
}
}
\seealso{
\code{\link{plot.bvar_fcast}}; \code{\link{bv_fcast}}
}
\keyword{BVAR}
\keyword{VAR}
\keyword{forecasts}
\keyword{prediction}
\keyword{quantiles}
