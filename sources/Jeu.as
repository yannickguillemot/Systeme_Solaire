/* Projet IN42 : Introduction au multimédia. 
Réalisé par Guillemot Yannick et Grosperrin Quentin
Printemps 2011 */
package {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import flash.utils.*;
	// Importation des tween
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	import Texte;

	public class Jeu extends MovieClip {
		
		//divers variables
		var catcher:soucoupe;
		var tScore:Texte;
		var tPlanete:Texte;
		var nextObject:Timer;
		var texteobjects:Array = new Array();
		var objects:Array = new Array();
		
		//vitesse de défilement des planètes
		const speed:Number=7.0;
		
		//score du jeu
		var score:int=0;

		public function Jeu() {
			
			//ajout de la soucoupe sur le bas de la scène
			catcher = new soucoupe();
			catcher.y=350;
			addChild(catcher);
			
			//ajout du texte du score
			tScore = new Texte(500,0,50,50,30,0xCCCCCC,"Calibri");
			tScore.Modifier_Texte(score.toString());
			addChild(tScore);
			
			
			
			setNextObject();
			addEventListener(Event.ENTER_FRAME, moveObjects);
		}

		function setNextObject() {
			nextObject=new Timer(1000+Math.random()*1000,1);
			nextObject.addEventListener(TimerEvent.TIMER_COMPLETE,newObject);
			nextObject.start();
		}

		function newObject(e:Event) {
			var random:int;
			var newObject:MovieClip;
			//ajout du nom de la planète affiché quand la planète est presque en bas
			tPlanete = new Texte(-100,20,100,50,20,0xFFFFFF,"Calibri");

			if (Math.random()<.5) {
				newObject = new tellurique();
				var r:int=Math.floor(Math.random()*newObject.totalFrames);
				newObject.gotoAndStop(r);
				newObject.typestr="good";
				if(r==1) 			tPlanete.Modifier_Texte("Mercure");
				else if(r==2) 		tPlanete.Modifier_Texte("Venus");
				else if(r==3) 		tPlanete.Modifier_Texte("Terre");
				else if(r==4) 		tPlanete.Modifier_Texte("Mars");

			} else {
				newObject = new gazeuse();
				r=Math.floor(Math.random()*newObject.totalFrames);
				newObject.gotoAndStop(r);
				newObject.typestr="bad";
				if(r==1) 		tPlanete.Modifier_Texte("Saturne");
				else if(r==2) 	tPlanete.Modifier_Texte("Jupiter");
				else if(r==3) 	tPlanete.Modifier_Texte("Uranus");
				else if(r==4) 	tPlanete.Modifier_Texte("Neptune");
			}
			random = Math.random()*500;
			newObject.x= random;
			tPlanete.x = random - newObject.width/2;
			tPlanete.alpha=0;
			addChild(newObject);
			addChild(tPlanete);

			objects.push(newObject);
			texteobjects.push(tPlanete);
			setNextObject();
		}

		function moveObjects(e:Event) {
			for (var i:int=objects.length-1; i>=0; i--) {
				objects[i].y+= speed;
				texteobjects[i].y+= speed ;
				if(objects[i].y>200) {
					//si la planète atteint la moitié de l'écran, on rajoute le nom de la planète pour aider le joueur
					 texteobjects[i].alpha=1;
					 //new Tween(tPlanete,"alpha",Regular.easeInOut,tPlanete.alpha,1,1,true);
				}
				if (objects[i].y>400) {
					removeChild(objects[i]);
					removeChild(texteobjects[i]);
					objects.splice(i,1);
					texteobjects.splice(i,1);
				}
				if (objects[i].hitTestObject(catcher)) {
					if (objects[i].typestr=="good") {
						score++;
					} else {
						score--;
					}
					if(score<0) score=0;
					removeChild(objects[i]);
					removeChild(texteobjects[i]);
					objects.splice(i,1);
					texteobjects.splice(i,1);
					tScore.Modifier_Texte(score.toString());
				}
			}
			if(mouseX<this.width && mouseX>0 && mouseY<this.height && mouseY>0)
				catcher.x=mouseX;
		}
		
		public function getScore() {
			return score;
		}
		
		public function Terminer() {
			//terminer à la fin du chrono
			removeChild(catcher);
			removeChild(tScore);
			nextObject.stop();
			removeEventListener(Event.ENTER_FRAME, moveObjects);
			for(var i:int=0; i<objects.length; i++)
				removeChild(objects[i]);
			for(i=0; i<texteobjects.length; i++)
				removeChild(texteobjects[i]);
		}


	}

}