// ActionScript file
import mx.events.ValidationResultEvent;
import mx.validators.EmailValidator;
import mx.validators.StringValidator;

import spark.components.TextInput;
import spark.validators.NumberValidator;

public var emailValidator:EmailValidator;
public var numberValidator:NumberValidator;
public var userIdValidator:StringValidator;
public var passwordValidator:StringValidator;


public var textBoxName:TextInput;
public var email:Boolean = false;

public function Validator_valid(evt:ValidationResultEvent):void {
    textBoxName.errorString = "";
}

public function Validator_invalid(evt:ValidationResultEvent):void {
    textBoxName.errorString = evt.message;

}

public function emailVerifyFunction():Boolean {
    var pass:Boolean = false;
    var vResult:ValidationResultEvent = new ValidationResultEvent("text");
    vResult = emailValidator.validate(textBoxName.text);

    if (vResult.type == ValidationResultEvent.VALID) {
        // Validation succeeded.
        pass = true;
    }
    else {
        // Validation failed.
        pass = false;
    }

    return pass;


}
public function userIDVerifyFunction():Boolean {
    var pass:Boolean = false;
    var vResult:ValidationResultEvent = new ValidationResultEvent("text");
    vResult = userIdValidator.validate(textBoxName.text);

    if (vResult.type == ValidationResultEvent.VALID) {
        // Validation succeeded.
        pass = true;
    }
    else {
        // Validation failed.
        pass = false;
    }

    return pass;


}
public function numberIDVerifyFunction():Boolean {
    var pass:Boolean = false;
    var vResult:ValidationResultEvent = new ValidationResultEvent("text");
    vResult = numberValidator.validate(textBoxName.text);

    if (vResult.type == ValidationResultEvent.VALID) {
        // Validation succeeded.
        pass = true;
    }
    else {
        // Validation failed.
        pass = false;
    }

    return pass;


}

public function passwordVerifyFunction():Boolean {
    var pass:Boolean = false;
    var vResult:ValidationResultEvent = new ValidationResultEvent("text");
    vResult = passwordValidator.validate(textBoxName.text);

    if (vResult.type == ValidationResultEvent.VALID) {
        // Validation succeeded.
        pass = true;
    }
    else {
        // Validation failed.
        pass = false;
    }

    return pass;


}
