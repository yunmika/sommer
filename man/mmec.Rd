\name{mmec}
\alias{mmec}
\title{

\strong{m}ixed \strong{m}odel \strong{e}quations for \strong{c} coefficients

}
\description{

Sommer is a structural multivariate-univariate linear mixed model solver for multiple random effects allowing the specification and/or estimation of variance covariance structures. The \code{mmec} function uses the MME-based Average Information algorithm coded in C++ using the Armadillo library to optimize matrix operations common in problems with sparse covariance structures such as genotype by environment models. These algorithm are \strong{intended to be used for problems of the type r > c (r records and c coefficients)}. For problems with of the type p > n, the direct inversion algorithms are faster and we recommend to shift to the use of the \code{\link{mmer}} function.

\strong{For tutorials} on how to perform different analysis with sommer please look at the vignettes by typing in the terminal:

\strong{vignette("v1.sommer.quick.start")} 

\strong{vignette("v2.sommer.changes.and.faqs")}

\strong{vignette("v3.sommer.qg")}

\strong{vignette("v4.sommer.gxe")}

}

\usage{

mmec(fixed, random, rcov, data, W, nIters=20, tolParConvLL = 1e-03, tolParConvNorm = 0.05,
     tolParInv = 1e-06, naMethodX="exclude", naMethodY="exclude",
     returnParam=FALSE, dateWarning=TRUE,verbose=TRUE, 
     addScaleParam=NULL, stepWeight=NULL, emWeight=NULL)
}
\arguments{
  \item{fixed}{A formula specifying the \strong{response variable(s)} \strong{and fixed effects}, i.e:
  
  \emph{response ~ covariate}
  
  }
  
  \item{random}{A formula specifying the name of the \strong{random effects}, i.e. \emph{random= ~ genotype + year}.
  
  Useful functions can be used to fit heterogeneous variances and other special models (\emph{see 'Special Functions' in the Details section for more information}):
  
  \code{\link{vsc}(...,Gu)} is the main function to specify variance models and special structures for random effects. On the ... argument you provide the unknown variance-covariance structures (i.e. usc,dsc,at,csc) and the random effect where such covariance structure will be used (the random effect of interest). Gu is used to provide known covariance matrices among the levels of the random effect. Auxiliar functions for building the variance models are:
  
  ** \code{\link{dsc}(x)}, \code{\link{usc}(x)}, \code{\link{csc}(x)}, \code{\link{isc}(x)}, and \code{\link{atr}(x,levs)} can be used to specify unknown diagonal, unstructured and customized unstructured and diagonal covariance structures to be estimated by REML.
  
  ** \code{\link{unsm}(x)}, \code{\link{fixm}(x)} and \code{\link{diag}(x)} can be used to build easily matrices to specify constraints in the Gtc argument of the \code{\link{vsc}()} function.
  
  ** \code{\link{overlay}()}, \code{\link{spl2Dc}()}, and \code{\link{leg}()} functions can be used to specify overlayed of design matrices of random effects, two dimensional spline and random regression models within the \code{\link{vsc}()} function.
  
  }
  \item{rcov}{A formula specifying the name of the \strong{error term}, i.e. \emph{rcov= ~ units}.
  
  Special heterogeneous and special variance models and constraints for the residual part are the same used on the random term but the name of the random effect is always "units" which can be thought as a column with as many levels as rows in the data, i.e. \emph{rcov=~vsc(dsc(covariate),isc(units))}
  
  }
  \item{data}{A data frame containing the variables specified in the formulas for response, fixed, and random effects.}
  \item{W}{Alternatively, instead of providing a vector of weights the user can specify an entire W matrix (e.g., when covariances exist). To be used first to produce Wis = solve(chol(W)), and then calculate R = Wsi*R*Wsi.t(), where * is the matrix product, and R is the residual matrix. Only one of the arguments weights or W should be used. If both are indicated W will be given the preference.}
   \item{nIters}{Maximum number of iterations allowed.}
  \item{tolParConvLL}{Convergence criteria based in the change of log-likelihood between iteration i and i-1.}
  \item{tolParConvNorm}{Convergence criteria based in the norm proposed by Jensen, Madsen and Thompson (1997):
  
  e1 = || InfMatInv.diag()/sqrt(N) * dLu ||
  
  where InfMatInv.diag() is the diagonal of the inverse of the information matrix, N is the total number of variance components, and dLu is the vector of first derivatives.
  
  }
  \item{tolParInv}{Tolerance parameter for matrix inverse used when singularities are encountered in the estimation procedure.}
   \item{naMethodX}{One of the two possible values; "include" or "exclude". If "include" is selected then the function will impute the X matrices for fixed effects with the median value. If "exclude" is selected it will get rid of all rows with missing values for the X (fixed) covariates. The default is "exclude". The "include" option should be used carefully.}
   \item{naMethodY}{One of the three possible values; "include", "include2" or "exclude" (default) to treat the observations in response variable to be used in the estimation of variance components. The first option "include" will impute the response variables for all rows with the median value, whereas "include2" imputes the responses only for rows where there is observation(s) for at least one of the responses (only available in the multi-response models). If "exclude" is selected (default) it will get rid of rows in response(s) where missing values are present for at least one of the responses.}
   \item{returnParam}{A TRUE/FALSE value to indicate if the program should return the parameters to be used for fitting the model instead of fitting the model.}
   \item{dateWarning}{A TRUE/FALSE value to indicate if the program should warn you when is time to update the sommer package.}
  \item{verbose}{A TRUE/FALSE value to indicate if the program should return the progress of the iterative algorithm.}
  \item{addScaleParam}{additional scale parameters for the thetaF matrix.}
  \item{stepWeight}{A vector of values (of length equal to the number of iterations) indicating the weight used to multiply the update (delta) for variance components at each iteration. If NULL the 1st iteration will be multiplied by 0.5, the 2nd by 0.7, and the rest by 0.9. This argument can help to avoid that variance components go outside the parameter space in the initial iterations which happens very often with the AI method but it can be detected by looking at the behavior of the likelihood. In that case you may want to give a smaller weight.}
  \item{emWeight}{A vector of values (of length equal to the number of iterations) indicating with values between 0 and 1 the weight assigned to the EM information matrix. And the values 1 - emWeight will be applied to the AI information matrix to produce a joint information matrix. By default the function gives a weight to the EM algorithm of 1, 0.9, 0.8, 0.7, 0.6, 0.4, 0.2 to the first 7 iterations and the rest a value 0.04. You can modify this argument by providing a different vector with as many values as iterations.}
    
}

\details{

The use of this function requires a good understanding of mixed models. Please review the 'sommer.quick.start' vignette and pay attention to details like format of your random and fixed variables (e.g. character and factor variables have different properties when returning BLUEs or BLUPs, please see the 'sommer.changes.and.faqs' vignette). 

\strong{Citation}

Type \emph{citation("sommer")} to know how to cite the sommer package in your publications. 

\strong{Special variance structures}

 \code{\link{vsc}(\link{atc}(x,levels),isc(y))}   
 
 can be used to specify heterogeneous variance for the "y" covariate at specific levels of the covariate "x", i.e. \emph{random=~vsc(at(Location,c("A","B")),isc(ID))} fits a variance component for ID at levels A and B of the covariate Location.
  
 \code{\link{vsc}(\link{dsc}(x),isc(y))}   
 
 can be used to specify a diagonal covariance structure for the "y" covariate for all levels of the covariate "x", i.e. \emph{random=~vsc(dsc(Location),isc(ID))}  fits a variance component for ID at all levels of the covariate Location.
  
 \code{\link{vsc}(\link{usc}(x),isc(y))}   
 
 can be used to specify an unstructured covariance structure for the "y" covariate for all levels of the  covariate "x", i.e. \emph{random=~vsc(usc(Location),isc(ID))}  fits variance and covariance components for ID at all levels of the covariate Location.
 
  \code{\link{vsc}(isc(\link{overlay}(...,rlist=NULL,prefix=NULL)))}   
 
 can be used to specify overlay of design matrices between consecutive random effects specified, i.e. \emph{random=~vsc(overlay(male,female))} overlays (overlaps) the incidence matrices for the male and female random effects to obtain a single variance component for both effects. The `rlist` argument is a list with each element being a numeric value that multiplies the incidence matrix to be overlayed. See \code{\link{overlay}} for details.Can be combined with vsc().
  
  \code{\link{vsc}(\link{leg}(x,n),isc(y))}
      
  can be used to fit a random regression model using a numerical variable \code{x} that marks the trayectory for the random effect \code{y}. The leg function can be combined with the special functions \code{dsc}, \code{usc} \code{at} and \code{csc}. For example \emph{random=~vsc(leg(x,1),isc(y))} or \emph{random=~vsc(usc(leg(x,1)),isc(y))}.
  
  \code{\link{spl2Dc}(x.coord, y.coord, at.var, at.levels))}
      
  can be used to fit a 2-dimensional spline (i.e. spatial modeling) using coordinates \code{x.coord} and \code{y.coord} (in numeric class) assuming multiple variance components. The 2D spline can be fitted at specific levels using the \code{at.var} and \code{at.levels} arguments. For example \emph{random=~spl2Dc(x.coord=Row,y.coord=Range,at.var=FIELD)}.

\strong{S3 methods}{

S3 methods are available for some parameter extraction such as \code{\link{fitted.mmec}}, \code{\link{residuals.mmec}}, \code{\link{summary.mmec}}, \code{\link{randef}}, \code{\link{coef.mmec}}, \code{\link{anova.mmec}}, \code{\link{plot.mmec}}, and \code{\link{predict.mmec}} to obtain adjusted means. In addition, the \code{\link{vpredict}} function (replacement of the pin function) can be used to estimate standard errors for linear combinations of variance components (i.e. ratios like h2). 

}

\strong{Additional Functions}

Additional functions for genetic analysis have been included such as relationship matrix building (\code{\link{A.mat}}, \code{\link{D.mat}}, \code{\link{E.mat}}, \code{\link{H.mat}}),  build a genotypic hybrid marker matrix (\code{\link{build.HMM}}), plot of genetic maps (\code{\link{map.plot}}), and manhattan plots (\code{\link{manhattan}}). If you need to build a pedigree-based relationship matrix use the \code{getA} function from the pedigreemm package. 

\strong{Bug report and contact}{

If you have any technical questions or suggestions please post it in https://stackoverflow.com or https://stats.stackexchange.com 

If you have any bug report please go to https://github.com/covaruber/sommer or send me an email to address it asap, just make sure you have read the vignettes carefully before sending your question.

}
\strong{Example Datasets}

The package has been equiped with several datasets to learn how to use the sommer package: 

* \code{\link{DT_halfdiallel}}, \code{\link{DT_fulldiallel}} and \code{\link{DT_mohring}} datasets have examples to fit half and full diallel designs. 

* \code{\link{DT_h2}} to calculate heritability

* \code{\link{DT_cornhybrids}} and \code{\link{DT_technow}} datasets to perform genomic prediction in hybrid single crosses 

* \code{\link{DT_wheat}} dataset to do genomic prediction in single crosses in species displaying only additive effects.

* \code{\link{DT_cpdata}} dataset to fit genomic prediction models within a biparental population coming from 2 highly heterozygous parents including additive, dominance and epistatic effects. 

* \code{\link{DT_polyploid}} to fit genomic prediction and GWAS analysis in polyploids. 

* \code{\link{DT_gryphon}} data contains an example of an animal model including pedigree information.

* \code{\link{DT_btdata}} dataset contains an animal (birds) model.

* \code{\link{DT_legendre}} simulated dataset for random regression model.

* \code{\link{DT_sleepstudy}} dataset to know how to translate lme4 models to sommer models.

* \code{\link{DT_ige}} dataset to show how to fit indirect genetic effect models.

\strong{Models Enabled}

For details about the models enabled and more information about the covariance structures please check the help page of the package (\code{\link{sommer}}).

}

\value{
If all parameters are correctly indicated the program will return a list with the following information:

\item{llik}{the vector of log-likelihoods across iterations}
\item{M}{the coeficient matrix extended by the response vector y] }
\item{W}{the column binded matrix W = [X Z y] }
\item{b}{the vector of fixed effect.}
\item{u}{the vector of random effect.}
\item{Ci}{the inverse of the coefficient matrix.}
\item{avInf}{The matrix of second derivatives of the likelihood with respect to the i.j th variance-covariance component.}
\item{monitor}{The values of the variance-covariance components across iterations during the REML estimation.}
\item{constraints}{The vector of constraints.}
\item{AIC}{Akaike information criterion}
\item{BIC}{Bayesian information criterion}
\item{convergence}{a TRUE/FALSE statement indicating if the model converged.}
\item{partitions}{a list where each element contains a matrix indicating where each random effect starts and ends.}
\item{percDelta}{the matrix of percentage change in deltas.}
\item{normMonitor}{the matrix of the three norms calculated.}
\item{toBoundary}{the matrix of variance components that were forced to the boundary across iterations.}

}
\references{

Jensen, J., Mantysaari, E. A., Madsen, P., and Thompson, R. (1997). Residual maximum likelihood estimation of (co) variance components in multivariate mixed linear models using average information. Journal of the Indian Society of Agricultural Statistics, 49, 215-236.

Covarrubias-Pazaran G. Genome assisted prediction of quantitative traits using the R package sommer. PLoS ONE 2016, 11(6): doi:10.1371/journal.pone.0156744   

Gilmour et al. 1995. Average Information REML: An efficient algorithm for variance parameter estimation in linear mixed models. Biometrics 51(4):1440-1450.

}
\author{
Giovanny Covarrubias-Pazaran
}
\examples{

####=========================================####
#### For CRAN time limitations most lines in the 
#### examples are silenced with one '#' mark, 
#### remove them and run the examples
####=========================================####

####=========================================####
#### EXAMPLES
#### Different models with sommer
####=========================================####

data(DT_example)
DT <- DT_example
head(DT)

####=========================================####
#### Univariate homogeneous variance models  ####
####=========================================####

## Compound simmetry (CS) model
ans1 <- mmec(Yield~Env,
             random= ~ Name + Env:Name,
             rcov= ~ units,
             data=DT)
summary(ans1)

####===========================================####
#### Univariate heterogeneous variance models  ####
####===========================================####
DT=DT[with(DT, order(Env)), ]
## Compound simmetry (CS) + Diagonal (DIAG) model
ans2 <- mmec(Yield~Env,
             random= ~Name + vsc(dsc(Env),isc(Name)),
             rcov= ~ vsc(dsc(Env),isc(units)),
             data=DT)
summary(ans2)

####===========================================####
####  Univariate unstructured variance models  ####
####===========================================####

ans3 <- mmec(Yield~Env,
             random=~ vsc(usc(Env),isc(Name)),
             rcov=~vsc(dsc(Env),isc(units)), 
             data=DT)
summary(ans3)

}