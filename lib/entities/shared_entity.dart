library shared_entity;

import '../components/shared_component.dart';
import 'dart:mirrors';
import 'dart:convert';

final RegExp init = new RegExp(r"\_init[A-Z][a-z]*");
final RegExp update = new RegExp(r"\_update[A-Z][a-z]*");
final RegExp collision = new RegExp(r"\_collision[A-Z][a-z]*");

abstract class SharedEntity{
  List <SharedEntity> _rulesSoFar = [];

  List<Symbol> componentUpdateFunctionList = [],
               componentCollisionCheckFunctionList = [];

  double movementSpeed;

  InstanceMirror lookAtMe;

  Vector velocity = new Vector(0.0,0.0),
         position = new Vector(0.0,0.0);

  double x,
         y,
         pivotX,  //TODO will have to figure out how to emulate these?!?! might be easy they just
         pivotY;

  addAllComponentInformation(Object obj) {
    /* This reflects over every mixin, finding methods that begin with
    *  _init, _update, or collision.  _init gets called immediately acting like
    * a constructor. _update gets called every frame first before collision check, which
    * gets called last.
    * */
    InstanceMirror instanceMirror = reflect(obj);
    ClassMirror currentClass = instanceMirror.type;
    Map members;
    while (currentClass.simpleName != #Object) {
      members = currentClass.declarations;
      for (var i in members.values) {
        if (!(null == init.firstMatch(i.simpleName.toString()))) {
          instanceMirror.invoke(i.simpleName, []);
        }
        else if (!(null == update.firstMatch(i.simpleName.toString()))) {
          if (!(i.simpleName.toString().contains("Drag"))) {
            componentUpdateFunctionList.add(i.simpleName);
          }
        }
        else if (!(null == collision.firstMatch(i.simpleName.toString()))) {
            if (!(i.simpleName.toString().contains("Drag"))) {
              componentCollisionCheckFunctionList.add(i.simpleName);
            }
          }
      }
      currentClass = currentClass.superclass;
    }
  }


  updateAllComponents(num time){
    //Update
    for(var i = componentUpdateFunctionList.length - 1; i >= 0; i--){
      lookAtMe.invoke(componentUpdateFunctionList[i], [time]);

    }
    //Check Collisions
    for(var i = componentCollisionCheckFunctionList.length - 1; i >= 0; i--){
      lookAtMe.invoke(componentCollisionCheckFunctionList[i], [time]);
    }
    //Finally, position the objects
    this..x = position.x
        ..y = position.y;
  }

  Map toJson(){
    Map<String, Object> json = {};
    ClassMirror currentClass = lookAtMe.type;
    while (currentClass.simpleName != #Object){
      for (var symbol in currentClass.declarations.values) {
        if (symbol is VariableMirror) {
          var v = symbol.simpleName;
          if(!(v == #lookAtMe)
             && !(v == #componentUpdateFunctionList)
             && !(v == #componentCollisionCheckFunctionList)
             && !(v == #_rulesSoFar)
             && !(v == #keysBeingPressed)){
            json[MirrorSystem.getName(v)] = lookAtMe.getField(v).reflectee.toString();
          }
        }
      }
      currentClass = currentClass.superclass;
    }
    return json;
  }
}
