/* cdd_both_reps.c: compute reduced H and V representation of polytope
   by Volker Braun <vbraun@stp.dias.ie>
   
   The input is taken from stdin and can be either a 
   H or V representation, not necessarily reduced.

   based on testcdd1.c, redcheck.c, and of course the cdd library
   written by Komei Fukuda, fukuda@ifor.math.ethz.ch
   Standard ftp site: ftp.ifor.math.ethz.ch, Directory: pub/fukuda/cdd
*/

/*  This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include "setoper.h"
#include "cdd.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>

time_t walltime_begin;

void timer_start()
{
  time(&walltime_begin);
}

void timer_end(const char * message)
{
  time_t walltime_end;
  double runtime;
  time(&walltime_end);
  runtime = difftime(walltime_end, walltime_begin);
  printf("# walltime used for %s: %.0fs\n", message, runtime);
}


int main(int argc, char *argv[])
{
  dd_PolyhedraPtr poly;
  dd_MatrixPtr M;
  dd_ErrorType err;
  dd_DataFileType inputfile;
  dd_MatrixPtr Hrep, Vrep;
  dd_SetFamilyPtr FacetGraph, VertexGraph;
  dd_rowindex newpos;
  dd_rowset impl_linset,redset;

  dd_set_global_constants();  /* First, this must be called. */

  /* Read data from stdin */
  M = dd_PolyFile2Matrix(stdin, &err);
  if (err != dd_NoError) goto EXIT;
  
  /* compute the second representation */
  timer_start();
  poly = dd_DDMatrix2Poly(M, &err);
  if (err != dd_NoError) goto EXIT;
  dd_FreeMatrix(M);
  timer_end("complementary representation");

  /* compute canonical H-representation */
  timer_start();
  Hrep = dd_CopyInequalities(poly);
  if (Hrep->rowsize > 0) {  /* workaround for bug with empty matrix */
    dd_MatrixCanonicalize(&Hrep, &impl_linset, &redset, &newpos, &err);
    if (err != dd_NoError) goto EXIT;
    set_free(redset);
    set_free(impl_linset);
    free(newpos);
  }
  timer_end("canonical H-representation");

  /* compute canonical V-representation */
  timer_start();
  Vrep = dd_CopyGenerators(poly);
  if (Vrep->rowsize > 0) {  /* workaround for bug with empty matrix */
    dd_MatrixCanonicalize(&Vrep, &impl_linset, &redset, &newpos, &err);
    if (err != dd_NoError) goto EXIT;
    set_free(redset);
    set_free(impl_linset);
    free(newpos);
  }
  timer_end("canonical V-representation");
  printf("\n");

  /* Output V-representation */
  dd_WriteMatrix(stdout,Vrep);
  printf("\n");

  /* Output H-representation */
  dd_WriteMatrix(stdout,Hrep); 
  printf("\n");

  /* Output adjacency of vertices/rays/lines */
  timer_start();
  printf("Vertex graph\n");
  if (Vrep->rowsize > 0) {  /* workaround for bug with empty polyhedron */
    /* compute adjacent vertices/rays/lines */
    VertexGraph = dd_Matrix2Adjacency(Vrep, &err);
    if (err != dd_NoError) goto EXIT;
    dd_WriteSetFamily(stdout,VertexGraph);
    dd_FreeSetFamily(VertexGraph);
  } else {
    printf("begin\n");
    printf("  0    0\n");
    printf("end\n");
  }
  timer_end("vertex adjacencies");
  printf("\n");
  
  /* Output adjacency of inequalities/equations */
  timer_start();
  printf("Facet graph\n");
  if (Hrep->rowsize > 0) {  /* workaround for bug with empty polyhedron */
    /* compute adjacent inequalities/equations */
    FacetGraph = dd_Matrix2Adjacency(Hrep, &err);
    if (err != dd_NoError) goto EXIT;
    dd_WriteSetFamily(stdout,FacetGraph);
    dd_FreeSetFamily(FacetGraph);
  } else {
    printf("begin\n");
    printf("  0    0\n");
    printf("end\n");
  }
  timer_end("facet adjacencies");
  printf("\n");

  /* Finally, free results data */
  dd_FreeMatrix(Hrep);
  dd_FreeMatrix(Vrep);
  dd_FreePolyhedra(poly);

EXIT:
  if (err != dd_NoError) {
    dd_WriteErrorMessages(stdout,err);
  }

  dd_free_global_constants();  /* At the end, this must be called. */
  return(0);
}



