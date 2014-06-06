require 'sinatra'
require 'pony'

Encoding.default_external = 'utf-8'

def ponysend
  Pony.mail({
    :to      => 'webmaster@mahi.dhamma.org',
    :subject => 'Formulaire de création de demande de group sitting de ' + params[:nomprenom],
    :body    => "<ul><li>Contact national : " + (if params[:contactnational] then 'oui' else 'non' end)  + "</li>" + 
                    "<li>Hôte d'un groupe de méditation : "  + (if params[:hotegroupemedit] then 'oui' else 'non' end) + "</li>" + 
                    "<br />" +  "<br />" +
                    "<li>Nom et prénom : " + params[:nomprenom] + "</li>" +
                    "<li>Adresse : " + params[:adresse] + "</li>" +
                    "<li>Téléphone portable : " + params[:telportable] + "</li>" + 
                    "<li>Téléphone fixe : " + params[:telfixe] + "</li>" + 
                    "<li> Adresse email : " + params[:adressemail] + "</li>" + 
                    "<br />" +  "<br />" +
                    "<li>Vivez-vous en couple (marié ou non) : " + params[:couple] + "</li>" + 
                    "<li>Nom du (de la) partenaire : " + params[:nompartenaire] + "</li>" + 
                    "<li>Votre partenaire pratique-t-il(elle) Vipassana tel que l'enseigne S.N. Goenka : " + params[:partenairepratique].to_s + "</li>" + 
                    "<br />" +  "<br />" +
                    "<li>Date premier cours : " + params[:datepremiercours] + "</li>" +
                    "<li>Lieu premier cours : " + params[:lieupremiercours] + "</li>" + 
                    "<li>Enseignant(s) premier cours : " + params[:enseignantpremiercours] + "</li>" +
                    "<li>Date dernier cours : " + params[:datederniercours] + "</li>" +
                    "<li>Lieu dernier cours : " + params[:lieuderniercours] + "</li>" +
                    "<li>Enseignant(s) dernier cours : " + params[:enseignantderniercours] + "</li>" +
                    "<li>Nombre total de cours de 10 jours - étudiant : " + params[:nbcoursassis] + "</li>" +
                    "<li>Nombre total de cours de 10 jours - servant : " + params[:nbcoursservis] + "</li>" +
                    "<li>Autres cours comme étudiant : " + params[:autrescoursassis] + "</li>" +
                    "<li>Autres cours comme servant : " + params[:autrescoursservis] + "</li>" +
                    "<li>Maintenez vous une pratique régulière de Vipassana ? : " + params[:pratiquereg] + "</li>" +
                    "<li>Veuillez détailler (combien de fois, combien de temps, quotidiennement etc). : " + params[:detailspratique] + "</li>" +
                    "<li>Pratiquez-vous d'autres techniques de méditation ? : " + params[:pratiqueautrestechniques] + "</li>" + 
                    "<li>Si oui, veuillez donner des détails : " + params[:detailpratiqueautrestechniques] + "</li>" +
                    "<li>Enseignez-vous ou pratiquez-vous sur autrui ? : " + params[:pratiqueautrui] + "</li>" +
                    "<li>Si oui, veuillez donner des détails : " + params[:detailpratiqueautrui] + "</li>" +
                    "<br />" +  "<br />" +
                    "<li>Au cours de l'année passée, avez-vous observé les Cinq Préceptes ? : " + params[:preceptes] + "</li>" +
                    "<li>Au cours de l'année passée, vous-êtes vous abstenu de toute inconduite sexuelle ? : " + params[:inconduitesexuelle] + "</li>" +
                    "<li>Au cours de l’année passée, vous-êtes vous totalement abstenu de prendre toute drogue, alcool et intoxicant ? : " + params[:drogue] + "</li>" +
                    "<br />" +  "<br />" +
                    "<li>Si vous comptez organiser les méditations de groupe chez vous, les lieux satisfont-ils les conditions requises ? : " + params[:lieux] + "</li>" +
                    "<li>Jours de la semaine et horaires des méditations de groupe : " + params[:jourshoraires] + "</li>" +
                    "<li>Nom assistant référent : " + params[:assistantreferent] + "</li></ul>",
    :via     => :smtp,
    :headers => { 'Content-Type' => 'text/html' },
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'meditationgrouprequest',
      :password             => 'Vipassana11',
      :authentication       => :plain, 
      :domain               => "localhost.localdomain" 
  }
})
end

def callform
	erb :form3
end

get '/form' do 
  @errors = []
  callform
end  

post '/form' do
  @errors = [] #creation of an error hash which will store all error messages
  @params = params #creation of a new variable which can be accessed outside of Ruby Code

  if params[:contactnational] != "true" && params[:hotegroupemedit] != "true"
    @errors << "Merci de préciser si vous voulez devenir contact national ou hôte d'un groupe officiel de méditation"
  end

  if params[:nomprenom].empty? || params[:adresse].empty? || params[:adressemail].empty?  
    @errors << "Vos coordonnées ne sont pas complètes"
  end

  if params[:telportable].empty? && params[:telfixe].empty?
    @errors << "Merci de renseigner au moins un numéro de téléphone"
  end

  if params[:couple].nil? || 
    params[:pratiquereg].nil? || 
    params[:pratiqueautrestechniques].nil? || 
    params[:pratiqueautrui].nil? || 
    params[:preceptes].nil? || 
    params[:inconduitesexuelle].nil? || 
    params[:drogue].nil? ||
    params[:lieux].nil? 
      @errors << "Certains champs Oui/Non n'ont pas été complétés" # syntax << is the same as a push commmand in Ruby
  end

  if params[:couple] == "Oui" && params[:nompartenaire].empty?         
    @errors << "Merci de renseigner le nom de votre partenaire"
  end

  if params[:couple] == "Oui" && params[:partenairepratique] != "Oui" && params[:partenairepratique] != "Non"          
    @errors << "Merci de préciser si votre partenaire pratique Vipassana"
  end

  if params[:datepremiercours].empty? ||
    params[:lieupremiercours].empty? ||
    params[:enseignantpremiercours].empty? ||
    params[:datederniercours].empty? ||
    params[:lieuderniercours].empty? ||
    params[:enseignantderniercours].empty? ||
    params[:nbcoursassis].empty? ||
    params[:nbcoursservis].empty? 
    @errors << "Merci de compléter toutes les informations relatives à vos cours assis et servis"
  end

  if params[:detailspratique].empty?
    @errors << "Merci de donner des détails sur votre pratique"
  end

  if params[:pratiqueautrestechniques] == "Oui" && params[:detailpratiqueautrestechniques].empty?
    @errors << "Merci de donner des détails sur les autres techniques de méditation que vous pratiquez"
  end

  if params[:pratiqueautrui] == "Oui" && params[:detailpratiqueautrui].empty?
    @errors << "Merci de donner des détails sur l'enseignement ou la pratique que vous prodiguez à autrui"
  end

  if params[:assistantreferent].empty?
    @errors << "Merci de compléter le nom d'un assistant référent"
  end

  if @errors.any?
    callform

  else  
    ponysend
    "Merci d'avoir complété le formulaire! Vous serez recontacté prochainement."
   end
  
end

