/* Projet IN42 : Introduction au multimédia. 
Réalisé par Guillemot Yannick et Grosperrin Quentin
Printemps 2011 */
package {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.system.fscommand;
	import flash.text.Font;
	import flash.display.DisplayObject;
	
	//Importation de la classe Texte qui nous permet de facilement générer du texte
	import Texte;
	
	public class CoursSysteme extends MovieClip {

		var canvas:Sprite;
		var canvas2:Sprite;
		var planetes:Array=new Array();
		//Un conteneur pour chaque slide
		var conteneur1:MovieClip;
		var conteneur2:MovieClip;
		var conteneur3:MovieClip;
		var conteneur4:MovieClip;
		
		/*Pour créer des interactions avec chaque planètes, on superpose à chaque fois 
		un clip d'une planète sur le background */
		var img1:id01;
		var img2:id02;
		var img3:id03;
		var img4:id04;
		var img5:id05;
		var img6:id06;
		var img7:id07;
		var img8:id08;
		
		var cercleAnim:rond = new rond();
		
		var tellur:telluriques;
		var gaz:gazeuses;
		
		var switch_btn1:point;
		var switch_btn2:point;
		var switch_btn3:point;
		var switch_btn4:point;
		
		var fontTitle:Font = new titleFont();
		var fontContent:Font = new contentFont();
		
		var monTween:Tween;
		var btn_down:pointDown;
		
		var nom:Texte;
		var contenu:Texte;
		
		var fond:back;
		

		public function CoursSysteme() {
			
			canvas = new Sprite();
			canvas2 = new Sprite();
			this.addChild(canvas);
			
			//Ajout des conteneurs au canvas principal.
			conteneur1 = new MovieClip();
			conteneur1.x = 0;
			canvas.addChild(conteneur1);
			canvas.setChildIndex(conteneur1, 0);
			conteneur2 = new MovieClip();
			conteneur2.x = 1024;
			canvas.addChild(conteneur2);
			canvas.setChildIndex(conteneur2, 1);
			conteneur3 = new MovieClip();
			conteneur3.x = 1024;
			canvas.addChild(conteneur3);
			canvas.setChildIndex(conteneur3, 2);
			conteneur4 = new MovieClip();
			conteneur4.x = 1024;
			canvas.addChild(conteneur4);
			canvas.setChildIndex(conteneur4, 3);
			
			//Ajout du background
			var anchorX:int = 20;
			var anchorY:int = 15;
			var fond:back = new back();
			fond.x = anchorX;
			fond.y = anchorY;
			conteneur1.addChild(fond)
			conteneur1.setChildIndex(fond, 0);
			
			//Superposition des planètes pour event
			conteneur1.addChild(canvas2);
			img1 = new id01();
			img1.x = 169 +anchorX;
			img1.y = 316 +anchorY;
			img1.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img1.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img1.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img1);
			img2 = new id02();
			img2.x = 225.8 +anchorX;
			img2.y = 271.35 +anchorY;
			img2.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img2.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img2.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img2);
			img3 = new id03();
			img3.x = 301.15 +anchorX;
			img3.y = 236.65 +anchorY;
			img3.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img3.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img3.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img3);
			img4 = new id04();
			img4.x = 346.7 +anchorX;
			img4.y = 194.8 +anchorY;
			img4.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img4.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img4.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img4);
			img5 = new id05();
			img5.x = 441.5 +anchorX;
			img5.y = 175.55 +anchorY;
			img5.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img5.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img5.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img5);
			img6 = new id06();
			img6.x = 533.4 +anchorX;
			img6.y = 114.8 +anchorY;
			img6.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img6.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img6.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img6);
			img7 = new id07();
			img7.x = 685 +anchorX;
			img7.y = 84 +anchorY;
			img7.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img7.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img7.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img7);
			img8 = new id08();
			img8.x = 763.95 +anchorX;
			img8.y = 37.75 +anchorY;
			img8.addEventListener(MouseEvent.MOUSE_OVER, survolPlanete);
			img8.addEventListener(MouseEvent.MOUSE_OUT, sortiePlanete);
			img8.addEventListener(MouseEvent.CLICK, clicPlanete);
			canvas2.addChild(img8);
			
			cercleAnim.visible = false;
			conteneur1.addChild(cercleAnim);

			// Ajout du titre
			nom = new Texte((1024/2), 325,  700, 70, 36, 0xFF6600, fontTitle.fontName);
			nom.Modifier_Texte("Planètes telluriques");
			conteneur2.addChild(nom);
			// Ajout de la description
			contenu = new Texte((1024/2)-50, 400, 400, 200, 18, 0xCCCCCC, fontContent.fontName);
			contenu.Modifier_HtmlTexte("Les planètes Telluriques sont les quatre planètes les plus " +
									   "près du Soleil: <font color='#FF6600'>Mercure, Vénus, Terre et Mars</font>. Elles sont appelées " +
									   "Telluriques parce qu'elles ont une <font color='#FF6600'>surface compacte et rocailleuse</font> " +
									   "comme celle de la Terre. Les planètes Vénus, Terre et Mars, ont des " +
									   "atmosphères importantes tandis que Mercure n'en a pratiquement pas.");
			conteneur2.addChild(contenu);
			tellur = new telluriques();
			tellur.x = (1024/2)-335;
			tellur.y = 203;
			conteneur2.addChild(tellur);
			
			// Ajout du titre
			nom = new Texte((1024/2)-00, 340, 700, 70, 36, 0xFF6600, fontTitle.fontName);
			nom.Modifier_Texte("Planètes gazeuses");
			conteneur3.addChild(nom);
			// Ajout de la description
			contenu = new Texte((1024/2)-200, 400, 400, 200, 18, 0xCCCCCC, fontContent.fontName);
			contenu.Modifier_HtmlTexte("<font color='#FF6600'>Jupiter, Saturne, Uranus et Neptune</font> sont connues sous le nom de " +
									   "planètes Joviennes, car elles sont gigantesques comparées à la Terre " +
									   "et parce qu'elles sont d'une nature gazeuse comme Jupiter. Les " +
									   "planètes Joviennes sont aussi appelées les <font color='#FF6600'>géantes gazeuses</font>, bien que " +
									   "certaines d'entre elles, ou toutes, devraient avoir de petits noyaux solides.");
			conteneur3.addChild(contenu);
			gaz = new gazeuses();
			gaz.x = (1024/2)-55;
			gaz.y = 65;
			conteneur3.addChild(gaz);
			
			// Ajout du titre
			nom = new Texte((1024/2)- 130, 320, 700, 70, 36, 0xFF6600, fontTitle.fontName);
			nom.Modifier_Texte("Le système solaire");
			conteneur4.addChild(nom);
			// Ajout de la description
			contenu = new Texte((1024/2)-250, 400, 600, 400, 18, 0xCCCCCC, fontContent.fontName);
			contenu.Modifier_HtmlTexte("Notre système solaire, <font color='#FF6600'>vieux de entre 4 et 5 milliards d'années</font>, consiste en une étoile moyenne le Soleil, les planètes <font color='#FF6600'>Mercure, Venus, "+
									   "Terre, Mars, Jupiter, Saturne, Uranus et Neptune</font>, ainsi que de la ceinture d'astéroïdes située entre Mars et Jupiter, dont le plus grand"+
									   "corps s'appelle Cérès. Le diamètre du système solaire avoisinne les <font color='#FF6600'>100 000 années lumières</font>."+
									   "Il inclue: les satellites des planètes, un "+
									   "certain nombre de comètes, et d'astéroïdes. On appelle lune un satellite formé naturellement, les astéroïdes peuvent en comporter."+
									   "Le soleil est la plus riche source d'énergie électromagnétique du système solaire. Tout le système solaire gravite à "+
									   "l'intérieur de notre galaxie: la Voie Lactée. Notre galaxie contient près de <font color='#FF6600'>220 milliards d'étoiles</font>."+
									   "<br>Le soleil renferme 99,85% de toute la matière du système solaire et pèse 2 × 10 puissance 30 kg. "+
									   "Le premier objet humain fut envoyé dans l'espace en <font color='#FF6600'>1957</font>.");
			conteneur4.addChild(contenu);
			
			
			btn_down = new pointDown();
			canvas.addChild(btn_down);
			btn_down.x = 1024/2 - 60;
			btn_down.y = 30;
			
			//Boutons de navigation
			switch_btn1 = new point();
			switch_btn1.x = 1024/2 - 60;
			switch_btn1.y = 30;
			switch_btn1.visible = false;
			switch_btn1.addEventListener(MouseEvent.CLICK,dotClick);
			canvas.addChild(switch_btn1);
			
			switch_btn2 = new point();
			switch_btn2.x = 1024/2 - 20;
			switch_btn2.y = 30;
			switch_btn2.addEventListener(MouseEvent.CLICK,dotClick);
			canvas.addChild(switch_btn2);
			
			switch_btn3 = new point();
			switch_btn3.x = 1024/2 + 20;
			switch_btn3.y = 30;
			switch_btn3.addEventListener(MouseEvent.CLICK,dotClick);
			canvas.addChild(switch_btn3);
			
			switch_btn4 = new point();
			switch_btn4.x = 1024/2 + 60;
			switch_btn4.y = 30;
			switch_btn4.addEventListener(MouseEvent.CLICK,dotClick);
			canvas.addChild(switch_btn4);
			
		}
		
		//Fonction appelée lorsque qu'une planète est survolée. On affiche une animation avec des cercles.
		function survolPlanete(event:Event):void{
			cercleAnim.x = event.target.x + event.target.width/2;
			cercleAnim.y = event.target.y + event.target.height/2;
			cercleAnim.scaleX = 1;
			cercleAnim.scaleY = 1;
			cercleAnim.visible = true;
		}
		
		function sortiePlanete(event:Event):void{
			cercleAnim.visible = false;
		}
		
		/*Fonction qui appelle un slide en fonction de la planète cliquer. 
		On a ajouté des effets de transitions */
		function clicPlanete(event:Event):void{
			conteneur1.alpha = 0.35;
			canvas2.alpha = 0;
			if (event.target == img1 || event.target == img2 || event.target == img3 || event.target == img4){
				//monTween = new Tween(conteneur1,"x",Regular.easeOut,0,-1024,0.5,true);
				monTween = new Tween(conteneur2,"x",Regular.easeOut,1024,0,0.5,true);
				conteneur3.x = 1024;
				conteneur4.x = 1024;
				switch_btn2.visible = false;
				switch_btn1.visible = true;
				switch_btn3.visible = true;
				switch_btn4.visible = true;
				btn_down.x = 1024/2 -20;
			}
			else {
				conteneur1.alpha = 0.35;
				monTween = new Tween(conteneur2,"x",Regular.easeOut,0,-1024,0.5,true);
				monTween = new Tween(conteneur3,"x",Regular.easeOut,1024,0,0.5,true);
				conteneur4.x = 1024;
				switch_btn3.visible = false;
				switch_btn1.visible = true;
				switch_btn2.visible = true;
				switch_btn4.visible = true;
				btn_down.x = 1024/2 + 20;
			}
		}
		
		//Tween sur les diapos
		public function dotClick(event:Event){
			if (event.target == switch_btn1){
				conteneur1.alpha = 1;
				canvas2.alpha = 1;
				monTween = new Tween(conteneur1,"x",Regular.easeOut,1024,0,0.5,true);
				conteneur3.x = 1024;
				conteneur2.x = 1024;
				conteneur4.x = 1024;
				switch_btn1.visible = false;
				switch_btn2.visible = true;
				switch_btn3.visible = true;
				switch_btn4.visible = true;
				btn_down.x = 1024/2 - 60;
			}
			if (event.target == switch_btn2){
				conteneur1.alpha = 0.35;
				canvas2.alpha = 0;
				monTween = new Tween(conteneur2,"x",Regular.easeOut,1024,0,0.5,true);
				conteneur3.x = 1024;
				conteneur4.x = 1024;
				switch_btn2.visible = false;
				switch_btn1.visible = true;
				switch_btn3.visible = true;
				switch_btn4.visible = true;
				btn_down.x = 1024/2 -20;
			}
			if (event.target == switch_btn3){
				conteneur1.alpha = 0.35;
				canvas2.alpha = 0;
				monTween = new Tween(conteneur2,"x",Regular.easeOut,0,-1024,0.5,true);
				monTween = new Tween(conteneur3,"x",Regular.easeOut,1024,0,0.5,true);
				//conteneur1.x = -1024;
				conteneur4.x = 1024;
				switch_btn3.visible = false;
				switch_btn1.visible = true;
				switch_btn2.visible = true;
				switch_btn4.visible = true;
				btn_down.x = 1024/2 + 20;
			}
			if (event.target == switch_btn4){
				conteneur1.alpha = 0.35;
				canvas2.alpha = 0;
				monTween = new Tween(conteneur3,"x",Regular.easeOut,0,-1024,0.5,true);
				monTween = new Tween(conteneur4,"x",Regular.easeOut,1024,0,0.5,true);
				conteneur3.x = 1024;
				conteneur2.x = 1024;
				switch_btn4.visible = false;
				switch_btn1.visible = true;
				switch_btn2.visible = true;
				switch_btn3.visible = true;
				btn_down.x = 1024/2 + 60;
			}
				
		}
	
		
	}
}