function _validate_profile(name::String, properties::Dict)
    valid = true

    try
        # TODO
    catch exception
        valid &= _vassert(false, "An unexpected exception occured"; location="Profile", name=name)
    end

    return valid
end
