# Definition of Done (DoD) – Projet PC4U

## 1. Objectif du document

Ce document définit les critères qui doivent être respectés pour qu’une fonctionnalité du projet **PC4U** soit considérée comme **terminée**.  
La *Definition of Done (DoD)* permet d’assurer une compréhension commune au sein de l’équipe et de garantir un niveau de qualité constant pour l’ensemble du projet.

---

## 2. Critères fonctionnels

Une fonctionnalité est considérée comme terminée lorsque :

- Elle répond au besoin fonctionnel défini au départ
- Elle est utilisable par l’utilisateur sans comportement inattendu
- Les résultats affichés sont cohérents avec l’action effectuée
- Aucun bug bloquant n’empêche son utilisation normale

---

## 3. Critères techniques

### 3.1 Backend

Pour être considérée comme terminée côté backend, une fonctionnalité doit respecter les critères suivants :

- La route API correspondante est implémentée et fonctionnelle
- Les requêtes HTTP retournent les bons codes de réponse
- Les données sont correctement traitées et validées
- La communication avec la base de données fonctionne sans erreur
- Les routes sensibles sont protégées par un mécanisme d’authentification si nécessaire
- Aucun message d’erreur critique n’apparaît dans les logs du serveur

---

### 3.2 Frontend

Pour être considérée comme terminée côté frontend, une fonctionnalité doit respecter les critères suivants :

- L’interface utilisateur affiche correctement les informations
- Les interactions utilisateur fonctionnent comme prévu
- Les appels vers l’API backend sont correctement effectués
- Les erreurs sont gérées de manière appropriée (messages ou redirections)
- La fonctionnalité est utilisable sans rechargement excessif ou blocage

---

## 4. Tests et validation

Une fonctionnalité est considérée comme terminée uniquement après avoir été testée :

- Les cas normaux d’utilisation ont été vérifiés
- Les cas d’erreur ou d’entrée invalide ont été testés
- La fonctionnalité ne provoque pas de régression sur les autres parties de l’application
- Le comportement observé correspond aux attentes définies

---

## 5. Intégration et gestion du code

Avant qu’une fonctionnalité soit considérée comme terminée :

- Le code est poussé sur le dépôt GitHub du projet
- La fonctionnalité est intégrée dans la branche appropriée
- Aucun conflit Git non résolu n’est présent
- Le code respecte l’architecture et la structure du projet
- Les fichiers modifiés sont cohérents avec les standards de l’équipe

---

## 6. Validation finale

Une fonctionnalité est officiellement considérée comme **Done** lorsque :

- Elle fonctionne dans l’environnement de développement
- Elle est accessible depuis le frontend
- Elle respecte les critères fonctionnels et techniques définis
- Elle est validée par au moins un membre de l’équipe

---

## 7. Conclusion

La *Definition of Done* permet à l’équipe du projet **PC4U** de maintenir une qualité constante, de mieux suivre l’avancement du projet et de s’assurer que chaque fonctionnalité livrée est complète, fonctionnelle et conforme aux objectifs fixés.

Ce document sert de référence tout au long du développement du projet.
