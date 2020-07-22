#############################################################
#################### FUNCTION GCtable #######################
## Author: Ehsan Fazel (Concordia University)              ##
## This version: September 2019                            ##
##                                                         ##
## This function returns the causality table for a set of  ## 
## vectors. It uses the definition of the causality        ##
## measure presented in Dufour and Taamouti (2010) and     ##
## obtains the measure for the first horizon.              ##
## VAR of order 1 is used in the computation. Estimation   ##
## method is equation by equation. Each row of the table   ##
## shows the measue from the row i to others.              ##
##                                                         ##
## Input: data. a T by N matrix, N is the number of        ##
## variables.                                              ##
## Output: N by N causality table                          ##
#############################################################
#############################################################
