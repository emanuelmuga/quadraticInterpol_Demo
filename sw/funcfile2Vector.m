function Vector = funcfile2Vector(DATA_WIDTH, FRAC_BITS, etiquetaV)

    fileID = fopen(etiquetaV, 'r');

    if fileID == -1
        error('No se pudo abrir el archivo');
    end

    str = strings(0);

    while true
        nextline = fgetl(fileID);
        if ~ischar(nextline)
            break;
        end

        line_trim = strtrim(nextline);

        % Ignorar líneas vacías
        if isempty(line_trim)
            continue;
        end

        % Ignorar comentarios tipo //
        if startsWith(line_trim, "//")
            continue;
        end

        % Ignorar líneas con X o x (valores indefinidos)
        if contains(line_trim, 'X') || contains(line_trim, 'x')
            continue;
        end

        str(end+1,1) = line_trim; %#ok<AGROW>
    end

    fclose(fileID);

    Vector = fi([],1,DATA_WIDTH,FRAC_BITS);
    Vector.hex = str;

end