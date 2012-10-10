/* Projet IN42 : Introduction au multimédia. 
Réalisé par Guillemot Yannick et Grosperrin Quentin
Printemps 2011 */
package {	

	import flash.text.* ;

	public class Texte extends TextField
	{
		var T_Format:TextFormat
		
		//Constructeur principal de la classe
		public function Texte(x:Number, y:Number, w:Number, h:Number, taille:Number, c:uint, police:String)
		{
			Position_Texte(x,y);
 			Taille_Texte(h,w);
			Couleur_Texte(c);
 
           selectable = false ;
		   //autoSize = TextFieldAutoSize.LEFT;
		   this.multiline = true;
		   this.wordWrap = true;
 			
		   T_Format = new TextFormat();
		   Format_Texte(taille, police);
		}
		
		public function Format_Texte(taille:Number, police:String)
		{
			T_Format.size=taille;
			T_Format.font=police;
			this.setTextFormat(T_Format);
			T_Format.align = "justify";
			
			this.defaultTextFormat = T_Format;
		}
		
		public function Position_Texte (x:Number, y:Number )
		{
			this.x = x ;
          	this.y = y ;
		}
		
		public function Taille_Texte (h:Number, w:Number)
		{
			height = h ;
            width = w ;
		}
		
		public function Couleur_Texte (c:uint)
		{
			textColor = c ;
		}
		
		public function Modifier_Texte(t:String)
		{
			this.text = t;
			
		}
		
		public function Modifier_HtmlTexte(t:String)
		{
			this.htmlText = t;
			
		}
		
		//Pour les tableaux de réponse
		public function Modifier_Texte_double(t:Array, nb:Number, nb2:Number)
		{
			this.text = t[nb][nb2];
			
		}
	}
}
	
