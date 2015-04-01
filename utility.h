//
//  utility.h
//  Système Info
//
//  Created by Rémi on 16/03/2015.
//

#ifndef __Syste_me_Info__utility__
#define __Syste_me_Info__utility__

#include <stdlib.h>

/**
 * La fonction agit comme si toReplace caractères étaient supprimés en début de replaced,
 * puis replacingLength caracères (extraits de replace) étaient ajoutés en début à la place.
 * Si replacingLength vaut 0, la vraie longueur de la chaine terminée par NUL est insérée.
 *
 * @param replaced 	      Le buffer dont les premieres caractères vont être remplacés.
 * @param toReplace       Le nombre de caractères supprimés
 * @param replacing       La chaîne d'où est extraite les caractères ajoutés. Elle doit contenir au moins replacingLength caractères.
 *                        Quand replacingLength vaut 0, la vraie longueur de la chaîne est calculée avec strlen -> la chaîne doit se terminer par un caractère NUL ('\0')
 * @param replacingLength Le nombre de caractères à insérer depuis replacing, ou 0 si l'on veut insérer toute la chaîne.
 */
void stringReplaceWithShorter(char *replaced, size_t toReplace, char const *replacing, size_t replacingLength);

#endif /* defined(__Syste_me_Info__utility__) */
