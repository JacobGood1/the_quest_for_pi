import '../components/shared_component.dart';
import 'dart:mirrors';

final RegExp init = new RegExp(r"\_init[A-Z][a-z]*");
final RegExp update = new RegExp(r"\_update[A-Z][a-z]*");
final RegExp collision = new RegExp(r"\_collision[A-Z][a-z]*");

abstract class SharedEntity implements SharedEntityData{
  List<Symbol> componentUpdateFunctionList = [],
               componentCollisionCheckFunctionList = [];

  double movementSpeed;

  InstanceMirror lookAtMe;

  Vector velocity = new Vector(0.0,0.0),
         position = new Vector(0.0,0.0);


  addAllComponentInformation(Object obj){
    /* This reflects over every mixin, finding methods that begin with
    *  _init, _update, or collision.  _init gets called immediately acting like
    * a constructor. _update gets called every frame first before collision check, which
    * gets called last.
    * */
    InstanceMirror instanceMirror = reflect(obj);
    ClassMirror currentClass = instanceMirror.type;
    Map members;
    while(currentClass.simpleName != #Object){
      members = currentClass.declarations;
      for(var i in members.values){
        if(!(null == init.firstMatch(i.simpleName.toString()))){
          instanceMirror.invoke(i.simpleName, []);
        }
        else if(!(null == update.firstMatch(i.simpleName.toString()))){
          if(!(i.simpleName.toString().contains("Drag"))){
            componentUpdateFunctionList.add(i.simpleName);
          }
        }
        else if(!(null == collision.firstMatch(i.simpleName.toString()))){
            if(!(i.simpleName.toString().contains("Drag"))){
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
    //print(x);
    this..x = position.x
        ..y = position.y;
  }
}

abstract class SharedEntityData{
  double x,
         y,
         pivotX,
         pivotY;
}