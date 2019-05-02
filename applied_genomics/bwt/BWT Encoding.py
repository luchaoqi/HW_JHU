def computeBWT(s):
    s = s +'$'
    rows = sorted(s[i:] + s[:i] for i in range(len(s)))
    bwt = [row[-1:] for row in rows]
    print("".join(bwt))
    return "".join(bwt)

def decodeBWT(r):
    rows = [""] * len(r)
    for i in range(len(r)):
        rows = sorted(r[i] + rows[i] for i in range(len(r)))
    s = [row for row in rows if row.endswith("$")][0]
    print(s.rstrip("$").strip())
    return s.rstrip("$").strip()
computeBWT('I_am_fully_convinced_that_species_are_not_immutable;_but_that_those_belonging_to_what_are_called_the_same_genera_are_lineal_descendants_of_some_other_and_generally_extinct_species,_in_the_same_manner_as_the_acknowledged_varieties_of_any_one_species_are_the_descendants_of_that_species._Furthermore,_I_am_convinced_that_natural_selection_has_been_the_most_important,_but_not_the_exclusive,_means_of_modification.')
decodeBWT('.uspe_gexr_______$..,e.orrs,sdddeedkdsuoden-tf,tyewtktttt,sewteb_ce__ww__h_PPsm_u_naseueeennnrrlmwwhWcrskkmHwhttv_no_nnwttzKt_l_ocoo_be___aaaooaAakiiooett_oooi_sslllfyyD__uouuueceetenagan___rru_aasanIiatt__c__saacooor_ootjeae______ir__a')



